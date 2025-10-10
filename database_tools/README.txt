AIVELLUM PRO - DATABASE TOOLS
==============================

QUICK START:
1. Run: python migrate_json_to_db.py    (First time only - converts JSON to SQLite)
2. Run: python cli.py                   (Interactive database manager)

FILES:
------
db_manager.py           - Core database functions (CRUD operations)
migrate_json_to_db.py   - Convert existing JSON to SQLite (run once)
add_prompts.py          - Batch add prompts (for AI assistants)
cli.py                  - Interactive CLI tool
requirements.txt        - Python dependencies (none needed - SQLite is built-in)

USAGE FOR AI ASSISTANTS:
------------------------
To add prompts, use add_prompts.py:

from add_prompts import add_prompts_batch

prompts = [
    {
        'category_id': 'marketing',
        'title': 'Your Prompt Title',
        'description': 'Brief description',
        'content': 'Full prompt content here...',
        'is_premium': 0,
        'difficulty': 'Medium',
        'estimated_time': '5 min',
        'tags': ['tag1', 'tag2']
    }
]
add_prompts_batch(prompts)

AFTER ADDING PROMPTS:
---------------------
Run: python db_manager.py
Then call: export_to_json()

This updates both the .db file AND the JSON file for the Flutter app.

DATABASE LOCATION:
------------------
SQLite DB: assets/data/prompts.db
JSON Export: assets/data/prompts_database.json

The Flutter app now uses SQLite directly, but JSON is kept as backup.
