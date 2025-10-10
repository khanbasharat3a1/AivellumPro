import sqlite3
import json
import os
from datetime import datetime

DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'assets', 'data', 'prompts.db')

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_database():
    """Initialize database with tables"""
    conn = get_connection()
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS categories (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            icon TEXT,
            color TEXT,
            prompt_count INTEGER DEFAULT 0
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS prompts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            content TEXT NOT NULL,
            is_premium INTEGER DEFAULT 0,
            difficulty TEXT,
            estimated_time TEXT,
            tags TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (category_id) REFERENCES categories(id)
        )
    ''')
    
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_category ON prompts(category_id)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_premium ON prompts(is_premium)')
    
    conn.commit()
    conn.close()
    print(f"✓ Database initialized at {DB_PATH}")

def add_category(id, name, description="", icon="", color="", prompt_count=0):
    """Add a new category"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT OR REPLACE INTO categories (id, name, description, icon, color, prompt_count)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (id, name, description, icon, color, prompt_count))
    conn.commit()
    conn.close()
    print(f"✓ Category added: {name}")

def add_prompt(category_id, title, description, content, is_premium=0, difficulty="Medium", estimated_time="5 min", tags=None):
    """Add a new prompt"""
    if tags is None:
        tags = []
    tags_json = json.dumps(tags)
    
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO prompts (category_id, title, description, content, is_premium, difficulty, estimated_time, tags)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', (category_id, title, description, content, is_premium, difficulty, estimated_time, tags_json))
    prompt_id = cursor.lastrowid
    
    cursor.execute('UPDATE categories SET prompt_count = prompt_count + 1 WHERE id = ?', (category_id,))
    conn.commit()
    conn.close()
    print(f"✓ Prompt added: {title} (ID: {prompt_id})")
    return prompt_id

def update_prompt(prompt_id, **kwargs):
    """Update prompt fields"""
    if 'tags' in kwargs and isinstance(kwargs['tags'], list):
        kwargs['tags'] = json.dumps(kwargs['tags'])
    
    fields = ', '.join([f"{k} = ?" for k in kwargs.keys()])
    values = list(kwargs.values()) + [prompt_id]
    
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(f'UPDATE prompts SET {fields} WHERE id = ?', values)
    conn.commit()
    conn.close()
    print(f"✓ Prompt {prompt_id} updated")

def delete_prompt(prompt_id):
    """Delete a prompt"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT category_id FROM prompts WHERE id = ?', (prompt_id,))
    result = cursor.fetchone()
    if result:
        category_id = result[0]
        cursor.execute('DELETE FROM prompts WHERE id = ?', (prompt_id,))
        cursor.execute('UPDATE categories SET prompt_count = prompt_count - 1 WHERE id = ?', (category_id,))
        conn.commit()
        print(f"✓ Prompt {prompt_id} deleted")
    conn.close()

def get_all_prompts():
    """Get all prompts"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM prompts ORDER BY id')
    prompts = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return prompts

def get_all_categories():
    """Get all categories"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM categories ORDER BY id')
    categories = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return categories

def search_prompts(query):
    """Search prompts by title, description, or tags"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        SELECT * FROM prompts 
        WHERE title LIKE ? OR description LIKE ? OR tags LIKE ?
        ORDER BY id
    ''', (f'%{query}%', f'%{query}%', f'%{query}%'))
    prompts = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return prompts

def export_to_json():
    """Export database to JSON format"""
    categories = get_all_categories()
    prompts = get_all_prompts()
    
    for prompt in prompts:
        prompt['tags'] = json.loads(prompt['tags']) if prompt['tags'] else []
        prompt['isPremium'] = bool(prompt.pop('is_premium'))
        prompt['categoryId'] = prompt.pop('category_id')
        prompt['estimatedTime'] = prompt.pop('estimated_time')
        prompt.pop('created_at', None)
    
    for cat in categories:
        cat['promptCount'] = cat.pop('prompt_count')
    
    data = {
        'categories': categories,
        'prompts': prompts,
        'pricing': {},
        'app_config': {'version': '1.3.0'}
    }
    
    json_path = os.path.join(os.path.dirname(DB_PATH), 'prompts_database.json')
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"✓ Exported to {json_path}")

if __name__ == '__main__':
    init_database()
