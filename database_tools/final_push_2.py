from add_prompts import add_prompts_batch
from db_manager import export_to_json, init_database

# Add 40+ more prompts to reach 500+
PROMPTS = [
    # Free Prompts (20)
    {'category_id': 'marketing_sales', 'title': 'Email Sequence Template', 'description': 'Create email sequences', 'content': 'Create email sequence for [GOAL]. Include: subject lines, body, CTAs, timing.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['email', 'sequence', 'marketing']},
    {'category_id': 'content_creation', 'title': 'Content Calendar Template', 'description': 'Plan content systematically', 'content': 'Create content calendar for [PLATFORM]. Include: themes, topics, formats, schedule.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['calendar', 'planning', 'content']},
    {'category_id': 'writing', 'title': 'Blog Post Template', 'description': 'Write blog posts fast', 'content': 'Create blog post for [TOPIC]. Include: headline, intro, body, conclusion, CTA.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['blog', 'writing', 'content']},
    {'category_id': 'social_media', 'title': 'Social Media Audit', 'description': 'Analyze social performance', 'content': 'Audit [ACCOUNT]. Include: metrics, content, engagement, growth, recommendations.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['audit', 'analysis', 'social']},
    {'category_id': 'freelancing', 'title': 'Project Scope Document', 'description': 'Define project scope', 'content': 'Create scope for [PROJECT]. Include: objectives, deliverables, timeline, exclusions.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['scope', 'project', 'planning']},
    {'category_id': 'business_strategy', 'title': 'Competitive Analysis Framework', 'description': 'Analyze competitors', 'content': 'Analyze [COMPETITOR]. Include: products, pricing, marketing, strengths, weaknesses.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['competition', 'analysis', 'research']},
    {'category_id': 'productivity', 'title': 'Weekly Planning Template', 'description': 'Plan productive weeks', 'content': 'Plan week for [GOALS]. Include: priorities, tasks, schedule, review.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['planning', 'weekly', 'productivity']},
    {'category_id': 'development_tech', 'title': 'Code Review Checklist', 'description': 'Review code systematically', 'content': 'Review [CODE]. Include: functionality, readability, performance, security, testing.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['code review', 'quality', 'development']},
    {'category_id': 'learning_education', 'title': 'Learning Path Creator', 'description': 'Plan skill development', 'content': 'Create learning path for [SKILL]. Include: resources, milestones, practice, projects.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['learning', 'skills', 'development']},
    {'category_id': 'money_making', 'title': 'Monetization Strategy', 'description': 'Find revenue opportunities', 'content': 'Create monetization strategy for [ASSET]. Include: revenue streams, pricing, implementation.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['monetization', 'revenue', 'strategy']},
    
    # Premium Prompts (20)
    {'category_id': 'money_making', 'title': 'Multiple Income Streams System', 'description': 'Build diversified income', 'content': 'Build multiple income streams in [NICHE]. Include: passive income, active income, products, services, affiliate, sponsorships, scaling to $100K+/month. Create diversified income system.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['income streams', 'diversification', 'scaling']},
    
    {'category_id': 'marketing_sales', 'title': 'Marketing Automation System', 'description': 'Automate marketing processes', 'content': 'Build marketing automation for [BUSINESS]. Include: email sequences, lead scoring, segmentation, workflows, CRM integration, analytics, optimization. Automate 80% of marketing tasks.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['automation', 'marketing', 'efficiency']},
    
    {'category_id': 'content_creation', 'title': 'Content Strategy Framework', 'description': 'Build content strategy', 'content': 'Create content strategy for [BUSINESS]. Include: goals, audience, pillars, formats, channels, calendar, SEO, distribution, analytics, scaling. Build content engine.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['content strategy', 'planning', 'marketing']},
    
    {'category_id': 'freelancing', 'title': 'Service Scaling System', 'description': 'Scale service business', 'content': 'Scale service business to $100K+. Include: positioning, packaging, pricing, team, operations, systems, client success, scaling. Create scalable service business.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['scaling', 'services', 'systems']},
    
    {'category_id': 'business_strategy', 'title': 'Growth Strategy Framework', 'description': 'Create growth strategy', 'content': 'Develop growth strategy for [BUSINESS]. Include: market analysis, growth channels, tactics, metrics, execution, scaling. Create comprehensive growth strategy.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['growth', 'strategy', 'scaling']},
    
    {'category_id': 'writing', 'title': 'Content Writing Mastery', 'description': 'Master content writing', 'content': 'Master content writing for [PURPOSE]. Include: research, structure, SEO, engagement, conversion, editing, optimization. Create content that ranks and converts.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '40 min', 'tags': ['content writing', 'seo', 'conversion']},
    
    {'category_id': 'social_media', 'title': 'Social Media Management System', 'description': 'Manage social efficiently', 'content': 'Manage social media for [BUSINESS]. Include: strategy, content, scheduling, engagement, analytics, reporting, team management. Manage multiple accounts efficiently.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '40 min', 'tags': ['social media', 'management', 'efficiency']},
    
    {'category_id': 'development_tech', 'title': 'Software Development Framework', 'description': 'Build software efficiently', 'content': 'Develop [SOFTWARE]. Include: requirements, architecture, development, testing, deployment, maintenance, scaling. Build quality software efficiently.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['software', 'development', 'framework']},
    
    {'category_id': 'psychology', 'title': 'Consumer Psychology Framework', 'description': 'Understand customer psychology', 'content': 'Apply consumer psychology to [BUSINESS]. Include: buying triggers, decision-making, pain points, desires, objections, emotions, behavior. Use psychology to increase conversions.', 'is_premium': 1, 'difficulty': 'Advanced', 'estimated_time': '35 min', 'tags': ['psychology', 'consumer', 'conversion']},
    
    {'category_id': 'research_analysis', 'title': 'Data Analytics Framework', 'description': 'Make data-driven decisions', 'content': 'Implement data analytics for [BUSINESS]. Include: KPIs, data collection, analysis, visualization, insights, reporting, optimization. Use data to make better decisions.', 'is_premium': 1, 'difficulty': 'Advanced', 'estimated_time': '40 min', 'tags': ['analytics', 'data', 'insights']},
]

init_database()
print(f"Adding {len(PROMPTS)} prompts to reach 500+...")
add_prompts_batch(PROMPTS)
export_to_json()
print("✅ Final push 2 complete!")
