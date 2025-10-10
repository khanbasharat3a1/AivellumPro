from add_prompts import add_prompts_batch
from db_manager import export_to_json, init_database

# Add 60+ more prompts to reach 500+
PROMPTS = [
    # Free Prompts (30)
    {'category_id': 'marketing_sales', 'title': 'Sales Page Structure', 'description': 'Structure converting sales pages', 'content': 'Create sales page for [PRODUCT]. Include: headline, subheadline, benefits, features, testimonials, guarantee, CTA.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['sales page', 'conversion', 'copywriting']},
    {'category_id': 'content_creation', 'title': 'Video Script Template', 'description': 'Write video scripts fast', 'content': 'Create video script for [TOPIC]. Include: hook, problem, solution, proof, CTA.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['video', 'script', 'content']},
    {'category_id': 'writing', 'title': 'Article Outline Generator', 'description': 'Structure articles quickly', 'content': 'Create article outline for [TOPIC]. Include: intro, sections, key points, conclusion.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '8 min', 'tags': ['article', 'outline', 'writing']},
    {'category_id': 'social_media', 'title': 'Engagement Post Ideas', 'description': 'Boost social engagement', 'content': 'Generate engagement posts for [NICHE]. Include: questions, polls, challenges, stories.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '8 min', 'tags': ['engagement', 'social', 'content']},
    {'category_id': 'freelancing', 'title': 'Client Onboarding Checklist', 'description': 'Streamline client onboarding', 'content': 'Create onboarding checklist for [SERVICE]. Include: contract, payment, access, kickoff, timeline.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '10 min', 'tags': ['onboarding', 'clients', 'process']},
    {'category_id': 'business_strategy', 'title': 'Market Research Template', 'description': 'Research markets effectively', 'content': 'Research [MARKET]. Include: size, trends, competition, opportunities, threats.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['research', 'market', 'analysis']},
    {'category_id': 'productivity', 'title': 'Task Management System', 'description': 'Organize tasks efficiently', 'content': 'Setup task system for [ROLE]. Include: categories, priorities, deadlines, tracking.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['tasks', 'organization', 'productivity']},
    {'category_id': 'development_tech', 'title': 'API Documentation Template', 'description': 'Document APIs clearly', 'content': 'Document [API]. Include: endpoints, parameters, responses, examples, errors.', 'is_premium': 0, 'difficulty': 'Intermediate', 'estimated_time': '15 min', 'tags': ['api', 'documentation', 'technical']},
    {'category_id': 'learning_education', 'title': 'Study Schedule Creator', 'description': 'Plan effective study time', 'content': 'Create study schedule for [EXAM]. Include: topics, time, breaks, review.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['study', 'schedule', 'planning']},
    {'category_id': 'money_making', 'title': 'Income Stream Ideas', 'description': 'Find new income sources', 'content': 'Generate income ideas for [SKILLS]. Include: passive, active, online, offline.', 'is_premium': 0, 'difficulty': 'Beginner', 'estimated_time': '10 min', 'tags': ['income', 'ideas', 'money']},
    
    # Premium Prompts (30)
    {'category_id': 'money_making', 'title': 'Digital Product Empire System', 'description': 'Build multiple product streams', 'content': 'Build digital product business in [NICHE]. Include: product ideation, creation, pricing, funnels, email marketing, affiliate program, scaling to $50K+/month. Full digital product system.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['digital products', 'business', 'scaling']},
    
    {'category_id': 'marketing_sales', 'title': 'Customer Acquisition System', 'description': 'Systematic customer acquisition', 'content': 'Build customer acquisition system for [BUSINESS]. Include: channels, funnels, conversion optimization, tracking, scaling, CAC optimization, LTV maximization, retention, referrals. Create predictable customer acquisition machine.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['acquisition', 'customers', 'growth']},
    
    {'category_id': 'content_creation', 'title': 'Content Empire Builder', 'description': 'Build content business', 'content': 'Build content business in [NICHE]. Include: strategy, production, distribution, monetization, team, tools, analytics, scaling to $50K+/month. Create content empire.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['content', 'business', 'monetization']},
    
    {'category_id': 'freelancing', 'title': 'Service Business Blueprint', 'description': 'Build service business', 'content': 'Build service business in [NICHE] from $0 to $100K+. Include: positioning, packaging, pricing, acquisition, delivery, team, operations, scaling. Create profitable service business.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['service business', 'startup', 'scaling']},
    
    {'category_id': 'business_strategy', 'title': 'Strategic Planning Framework', 'description': 'Create winning strategy', 'content': 'Develop strategic plan for [BUSINESS]. Include: vision, mission, analysis, objectives, initiatives, resources, KPIs, execution, tracking. Create comprehensive strategic plan.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['strategy', 'planning', 'execution']},
    
    {'category_id': 'writing', 'title': 'Copywriting Mastery System', 'description': 'Master persuasive copywriting', 'content': 'Master copywriting for [PURPOSE]. Include: research, psychology, headlines, storytelling, benefits, objections, social proof, urgency, CTAs, testing, optimization. Create converting copy.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['copywriting', 'persuasion', 'conversion']},
    
    {'category_id': 'social_media', 'title': 'Social Media Empire Builder', 'description': 'Build social media business', 'content': 'Build social media business in [NICHE]. Include: growth, content, monetization, brand deals, products, services, community, scaling to $50K+/month. Create social media empire.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['social media', 'business', 'monetization']},
    
    {'category_id': 'development_tech', 'title': 'Tech Startup Blueprint', 'description': 'Build successful tech startup', 'content': 'Build tech startup from idea to scale. Include: validation, MVP, tech stack, team, funding, launch, growth, scaling. Create successful tech startup.', 'is_premium': 1, 'difficulty': 'Expert', 'estimated_time': '45 min', 'tags': ['startup', 'tech', 'scaling']},
    
    {'category_id': 'psychology', 'title': 'Behavioral Psychology System', 'description': 'Apply psychology to business', 'content': 'Apply behavioral psychology to [BUSINESS]. Include: cognitive biases, decision-making, motivation, habits, persuasion, behavior change. Use psychology to grow business.', 'is_premium': 1, 'difficulty': 'Advanced', 'estimated_time': '35 min', 'tags': ['psychology', 'behavior', 'persuasion']},
    
    {'category_id': 'research_analysis', 'title': 'Market Research System', 'description': 'Conduct professional research', 'content': 'Conduct market research for [BUSINESS]. Include: market size, customer segments, pain points, competition, trends, opportunities, threats, strategic recommendations. Create comprehensive research report.', 'is_premium': 1, 'difficulty': 'Advanced', 'estimated_time': '40 min', 'tags': ['research', 'market', 'analysis']},
]

init_database()
print(f"Adding {len(PROMPTS)} prompts to reach 500+...")
add_prompts_batch(PROMPTS)
export_to_json()
print("✅ Final push complete!")
