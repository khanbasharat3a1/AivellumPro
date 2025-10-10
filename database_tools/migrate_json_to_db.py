import json
import os
from db_manager import init_database, add_category, add_prompt

def migrate():
    """Migrate existing JSON data to SQLite database"""
    json_path = os.path.join(os.path.dirname(__file__), '..', 'assets', 'data', 'prompts_database.json')
    
    if not os.path.exists(json_path):
        print(f"✗ JSON file not found at {json_path}")
        return
    
    print("Starting migration from JSON to SQLite...")
    init_database()
    
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Migrate categories
    if 'categories' in data:
        for cat in data['categories']:
            add_category(
                id=cat.get('id'),
                name=cat.get('name'),
                description=cat.get('description', ''),
                icon=cat.get('icon', ''),
                color=cat.get('color', ''),
                prompt_count=cat.get('promptCount', 0)
            )
    
    # Migrate prompts
    if 'prompts' in data:
        for prompt in data['prompts']:
            add_prompt(
                category_id=prompt.get('categoryId'),
                title=prompt.get('title'),
                description=prompt.get('description'),
                content=prompt.get('content'),
                is_premium=1 if prompt.get('isPremium', False) else 0,
                difficulty=prompt.get('difficulty', 'Medium'),
                estimated_time=prompt.get('estimatedTime', '5 min'),
                tags=prompt.get('tags', [])
            )
    
    print("\n✓ Migration completed successfully!")
    print(f"  Categories: {len(data.get('categories', []))}")
    print(f"  Prompts: {len(data.get('prompts', []))}")

if __name__ == '__main__':
    migrate()
