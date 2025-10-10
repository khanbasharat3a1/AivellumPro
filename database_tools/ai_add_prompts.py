"""
AI-FRIENDLY PROMPT ADDITION SCRIPT
===================================
This script is designed for AI assistants (like Cursor, GitHub Copilot, Amazon Q)
to easily add prompts to the database.

USAGE:
Just modify the PROMPTS_TO_ADD list below and run this script.
"""

from add_prompts import add_prompts_batch, show_categories, init_database
from db_manager import export_to_json

# ============================================================================
# ADD YOUR PROMPTS HERE
# ============================================================================

PROMPTS_TO_ADD = [
    {
        'category_id': 'marketing',
        'title': 'Viral Product Launch Strategy',
        'description': 'Create a complete product launch campaign',
        'content': 'Design a viral product launch strategy for [PRODUCT] targeting [AUDIENCE]. Include pre-launch teasers, launch day tactics, email sequences, social media posts, and influencer outreach plan.',
        'is_premium': 0,
        'difficulty': 'Advanced',
        'estimated_time': '15 min',
        'tags': ['product launch', 'viral marketing', 'strategy']
    },
    {
        'category_id': 'writing',
        'title': 'Persuasive Sales Page Writer',
        'description': 'Write high-converting sales page copy',
        'content': 'Write a persuasive sales page for [PRODUCT/SERVICE] that converts visitors into buyers. Include attention-grabbing headline, pain points, benefits, social proof, and strong CTA.',
        'is_premium': 0,
        'difficulty': 'Intermediate',
        'estimated_time': '12 min',
        'tags': ['copywriting', 'sales', 'conversion']
    },
    {
        'category_id': 'content',
        'title': 'YouTube Thumbnail Ideas Generator',
        'description': 'Generate click-worthy thumbnail concepts',
        'content': 'Create 10 eye-catching YouTube thumbnail ideas for videos about [TOPIC]. Include text overlay suggestions, color schemes, and visual elements that maximize CTR.',
        'is_premium': 0,
        'difficulty': 'Beginner',
        'estimated_time': '5 min',
        'tags': ['youtube', 'thumbnails', 'design']
    },
    {
        'category_id': 'freelancing',
        'title': 'Client Proposal Template Generator',
        'description': 'Create winning freelance proposals',
        'content': 'Generate a professional freelance proposal for [SERVICE] project. Include project understanding, approach, timeline, deliverables, pricing, and terms. Make it personalized for [CLIENT NAME].',
        'is_premium': 0,
        'difficulty': 'Intermediate',
        'estimated_time': '10 min',
        'tags': ['proposals', 'freelancing', 'clients']
    },
    {
        'category_id': 'business',
        'title': 'Competitor SWOT Analysis',
        'description': 'Analyze competitors strengths and weaknesses',
        'content': 'Perform a detailed SWOT analysis for [COMPETITOR] in the [INDUSTRY] market. Identify their strengths, weaknesses, opportunities, and threats. Suggest how to gain competitive advantage.',
        'is_premium': 0,
        'difficulty': 'Advanced',
        'estimated_time': '15 min',
        'tags': ['analysis', 'competition', 'strategy']
    },
    {
        'category_id': 'social_media',
        'title': 'Instagram Story Sequence Creator',
        'description': 'Design engaging Instagram story sequences',
        'content': 'Create a 10-slide Instagram story sequence about [TOPIC] that drives engagement and swipe-ups. Include hooks, value slides, interactive elements, and strong CTA.',
        'is_premium': 0,
        'difficulty': 'Beginner',
        'estimated_time': '8 min',
        'tags': ['instagram', 'stories', 'engagement']
    },
    {
        'category_id': 'productivity',
        'title': 'Weekly Goal Planning System',
        'description': 'Create an effective weekly planning routine',
        'content': 'Design a weekly goal planning system for [ROLE/PROFESSION]. Include goal setting framework, daily task breakdown, time blocking schedule, and progress tracking method.',
        'is_premium': 0,
        'difficulty': 'Beginner',
        'estimated_time': '7 min',
        'tags': ['planning', 'goals', 'productivity']
    },
    {
        'category_id': 'development',
        'title': 'API Documentation Generator',
        'description': 'Create clear API documentation',
        'content': 'Generate comprehensive API documentation for [API NAME]. Include endpoints, request/response examples, authentication, error codes, and usage examples in multiple languages.',
        'is_premium': 0,
        'difficulty': 'Intermediate',
        'estimated_time': '10 min',
        'tags': ['api', 'documentation', 'development']
    },
    {
        'category_id': 'learning',
        'title': 'Study Notes Summarizer',
        'description': 'Convert long content into concise study notes',
        'content': 'Summarize [TOPIC/CHAPTER] into concise study notes. Use bullet points, key concepts, definitions, examples, and memory aids. Make it easy to review before exams.',
        'is_premium': 0,
        'difficulty': 'Beginner',
        'estimated_time': '5 min',
        'tags': ['studying', 'notes', 'learning']
    },
    {
        'category_id': 'money_making',
        'title': 'Passive Income Idea Validator',
        'description': 'Validate and refine passive income ideas',
        'content': 'Analyze this passive income idea: [YOUR IDEA]. Evaluate market demand, competition, startup costs, time investment, scalability, and profit potential. Provide actionable next steps.',
        'is_premium': 0,
        'difficulty': 'Intermediate',
        'estimated_time': '12 min',
        'tags': ['passive income', 'validation', 'business']
    }
]

# ============================================================================
# SCRIPT EXECUTION
# ============================================================================

if __name__ == '__main__':
    print("AI Prompt Addition Tool")
    print("=" * 60)
    
    init_database()
    show_categories()
    
    if not PROMPTS_TO_ADD:
        print("\n⚠ No prompts to add. Edit PROMPTS_TO_ADD list in this file.")
        print("\nExample format:")
        print("""
{
    'category_id': 'marketing',
    'title': 'Your Prompt Title',
    'description': 'Brief description',
    'content': 'Full prompt content...',
    'is_premium': 0,
    'difficulty': 'Easy',
    'estimated_time': '5 min',
    'tags': ['tag1', 'tag2']
}
        """)
    else:
        print(f"\n📝 Adding {len(PROMPTS_TO_ADD)} prompts...")
        add_prompts_batch(PROMPTS_TO_ADD)
        
        print("\n📤 Exporting to JSON for Flutter app...")
        export_to_json()
        
        print("\n✅ DONE! Database updated and JSON exported.")
        print("   You can now run the Flutter app with updated prompts.")
