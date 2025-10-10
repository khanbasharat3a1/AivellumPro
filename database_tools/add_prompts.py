from db_manager import add_prompt, get_all_categories, init_database

def show_categories():
    """Display all available categories"""
    categories = get_all_categories()
    print("\nAvailable Categories:")
    print("-" * 50)
    for cat in categories:
        print(f"  {cat['id']}: {cat['name']} ({cat['prompt_count']} prompts)")
    print("-" * 50)

def add_prompts_batch(prompts_data):
    """
    Add multiple prompts at once
    
    Example usage:
    prompts = [
        {
            'category_id': 'marketing',
            'title': 'Social Media Post Generator',
            'description': 'Create engaging social media posts',
            'content': 'Generate a social media post about [TOPIC]...',
            'is_premium': 0,
            'difficulty': 'Easy',
            'estimated_time': '3 min',
            'tags': ['social media', 'marketing', 'content']
        }
    ]
    add_prompts_batch(prompts)
    """
    init_database()
    added = []
    
    for prompt in prompts_data:
        prompt_id = add_prompt(
            category_id=prompt.get('category_id'),
            title=prompt.get('title'),
            description=prompt.get('description'),
            content=prompt.get('content'),
            is_premium=prompt.get('is_premium', 0),
            difficulty=prompt.get('difficulty', 'Medium'),
            estimated_time=prompt.get('estimated_time', '5 min'),
            tags=prompt.get('tags', [])
        )
        added.append(prompt_id)
    
    print(f"\n✓ Added {len(added)} prompts successfully!")
    return added

# Example: Add prompts here
if __name__ == '__main__':
    init_database()
    show_categories()
    
    # ADD YOUR PROMPTS HERE
    # Example:
    # new_prompts = [
    #     {
    #         'category_id': 'marketing',
    #         'title': 'Email Campaign Creator',
    #         'description': 'Design effective email marketing campaigns',
    #         'content': 'Create an email campaign for [PRODUCT/SERVICE]...',
    #         'is_premium': 0,
    #         'difficulty': 'Medium',
    #         'estimated_time': '10 min',
    #         'tags': ['email', 'marketing', 'campaign']
    #     }
    # ]
    # add_prompts_batch(new_prompts)
    
    print("\nTo add prompts, edit this file and uncomment the example code.")
