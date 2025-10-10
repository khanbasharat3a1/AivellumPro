#!/usr/bin/env python3
import sys
from db_manager import *

def print_menu():
    print("\n" + "="*60)
    print("  AIVELLUM PRO - DATABASE MANAGER")
    print("="*60)
    print("1. View all categories")
    print("2. View all prompts")
    print("3. Add new prompt")
    print("4. Update prompt")
    print("5. Delete prompt")
    print("6. Search prompts")
    print("7. Export to JSON (for Flutter app)")
    print("8. Initialize/Reset database")
    print("0. Exit")
    print("="*60)

def view_categories():
    categories = get_all_categories()
    print(f"\n{'ID':<15} {'Name':<25} {'Prompts':<10}")
    print("-" * 60)
    for cat in categories:
        print(f"{cat['id']:<15} {cat['name']:<25} {cat['prompt_count']:<10}")

def view_prompts():
    prompts = get_all_prompts()
    print(f"\n{'ID':<5} {'Title':<40} {'Category':<15}")
    print("-" * 60)
    for p in prompts:
        print(f"{p['id']:<5} {p['title'][:38]:<40} {p['category_id']:<15}")
    print(f"\nTotal: {len(prompts)} prompts")

def add_new_prompt():
    print("\n--- Add New Prompt ---")
    view_categories()
    
    category_id = input("\nCategory ID: ").strip()
    title = input("Title: ").strip()
    description = input("Description: ").strip()
    content = input("Content: ").strip()
    is_premium = input("Is Premium? (y/n): ").strip().lower() == 'y'
    difficulty = input("Difficulty (Easy/Medium/Hard): ").strip() or "Medium"
    estimated_time = input("Estimated Time (e.g., 5 min): ").strip() or "5 min"
    tags_input = input("Tags (comma-separated): ").strip()
    tags = [t.strip() for t in tags_input.split(',')] if tags_input else []
    
    prompt_id = add_prompt(category_id, title, description, content, 
                          1 if is_premium else 0, difficulty, estimated_time, tags)
    print(f"\n✓ Prompt added with ID: {prompt_id}")

def update_existing_prompt():
    print("\n--- Update Prompt ---")
    prompt_id = input("Enter Prompt ID to update: ").strip()
    
    print("\nLeave blank to keep current value")
    updates = {}
    
    title = input("New Title: ").strip()
    if title: updates['title'] = title
    
    description = input("New Description: ").strip()
    if description: updates['description'] = description
    
    content = input("New Content: ").strip()
    if content: updates['content'] = content
    
    if updates:
        update_prompt(int(prompt_id), **updates)
    else:
        print("No updates provided")

def delete_existing_prompt():
    print("\n--- Delete Prompt ---")
    prompt_id = input("Enter Prompt ID to delete: ").strip()
    confirm = input(f"Are you sure you want to delete prompt {prompt_id}? (y/n): ").strip().lower()
    
    if confirm == 'y':
        delete_prompt(int(prompt_id))
    else:
        print("Deletion cancelled")

def search_prompts_cli():
    query = input("\nEnter search query: ").strip()
    results = search_prompts(query)
    
    print(f"\n{'ID':<5} {'Title':<40} {'Category':<15}")
    print("-" * 60)
    for p in results:
        print(f"{p['id']:<5} {p['title'][:38]:<40} {p['category_id']:<15}")
    print(f"\nFound: {len(results)} prompts")

def main():
    init_database()
    
    while True:
        print_menu()
        choice = input("\nEnter choice: ").strip()
        
        if choice == '1':
            view_categories()
        elif choice == '2':
            view_prompts()
        elif choice == '3':
            add_new_prompt()
        elif choice == '4':
            update_existing_prompt()
        elif choice == '5':
            delete_existing_prompt()
        elif choice == '6':
            search_prompts_cli()
        elif choice == '7':
            export_to_json()
        elif choice == '8':
            confirm = input("This will reset the database. Continue? (y/n): ").strip().lower()
            if confirm == 'y':
                init_database()
        elif choice == '0':
            print("\nGoodbye!")
            break
        else:
            print("\n✗ Invalid choice")

if __name__ == '__main__':
    main()
