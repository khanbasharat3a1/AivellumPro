#!/usr/bin/env python3
from db_manager import get_all_categories, get_all_prompts, get_connection

def show_stats():
    """Display database statistics"""
    categories = get_all_categories()
    prompts = get_all_prompts()
    
    print("\n" + "="*60)
    print("  AIVELLUM PRO - DATABASE STATISTICS")
    print("="*60)
    
    print(f"\n📊 Total Categories: {len(categories)}")
    print(f"📝 Total Prompts: {len(prompts)}")
    
    premium_count = sum(1 for p in prompts if p['is_premium'] == 1)
    free_count = len(prompts) - premium_count
    
    print(f"\n💎 Premium Prompts: {premium_count}")
    print(f"🆓 Free Prompts: {free_count}")
    
    print("\n📁 Prompts by Category:")
    print("-" * 60)
    for cat in sorted(categories, key=lambda x: x['prompt_count'], reverse=True):
        bar = "█" * (cat['prompt_count'] // 2)
        print(f"  {cat['name']:<30} {cat['prompt_count']:>3} {bar}")
    
    print("\n🎯 Difficulty Distribution:")
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT difficulty, COUNT(*) FROM prompts GROUP BY difficulty")
    for row in cursor.fetchall():
        print(f"  {row[0]:<15} {row[1]:>3}")
    conn.close()
    
    print("\n" + "="*60)

if __name__ == '__main__':
    show_stats()
