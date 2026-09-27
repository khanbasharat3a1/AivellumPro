# AI Assistant Guide: Adding Prompts to Aivellum Pro Database

## Quick Start (3 Steps)

1. **Edit `ai_add_prompts.py`** - Add your prompts to the `PROMPTS_TO_ADD` list
2. **Run the script** - `python ai_add_prompts.py`
3. **Done!** - Database and JSON automatically updated

---

## Available Categories

```python
'money_making'          # Money Making (61 prompts)
'content_creation'      # Content Creation (46 prompts)
'marketing_sales'       # Marketing & Sales (45 prompts)
'freelancing'           # Freelancing (45 prompts)
'social_media'          # Social Media (45 prompts)
'writing'               # Writing (41 prompts)
'business_strategy'     # Business & Strategy (39 prompts)
'development_tech'      # Development & Tech (32 prompts)
'learning_education'    # Learning & Education (26 prompts)
'productivity'          # Productivity & Planning (24 prompts)
'psychology'            # Psychology (21 prompts)
'research_analysis'     # Research & Analysis (16 prompts)
'fitness_health'        # Fitness & Health (11 prompts)
'ai_art'                # AI Art Generation (10 prompts)
'ai_automation'         # AI Automation (7 prompts)
'crypto_trading'        # Crypto & Trading (7 prompts)
'nft_creation'          # NFT Creation (7 prompts)
'virtual_reality'       # Virtual Reality (6 prompts)
'voice_cloning'         # Voice Cloning (5 prompts)
```

---

## Prompt Template

```python
{
    'category_id': 'marketing_sales',           # Choose from categories above
    'title': 'Your Prompt Title',              # Clear, descriptive (50 chars max)
    'description': 'Brief description',        # What it does (100 chars max)
    'content': 'Full prompt content...',       # Detailed prompt (can be long)
    'is_premium': 0,                           # 0 = free, 1 = premium
    'difficulty': 'Intermediate',              # Beginner, Intermediate, Advanced, Expert
    'estimated_time': '10 min',                # How long to use: '5 min', '10 min', '15 min', etc.
    'tags': ['tag1', 'tag2', 'tag3']          # 2-5 relevant tags
}
```

---

## Quality Guidelines

### ✅ GOOD Prompts

**1. Specific & Actionable**
```python
{
    'category_id': 'marketing_sales',
    'title': 'Email Subject Line Generator',
    'description': 'Create high-open-rate email subject lines',
    'content': 'Generate 20 email subject line variations for [TOPIC/OFFER]. Include: curiosity-driven, benefit-focused, urgency-based, and personalized angles. Test for mobile preview length and spam trigger words.',
    'is_premium': 0,
    'difficulty': 'Beginner',
    'estimated_time': '5 min',
    'tags': ['email', 'subject lines', 'open rates']
}
```

**2. Detailed & Comprehensive (Premium)**
```python
{
    'category_id': 'money_making',
    'title': 'E-Commerce Empire Builder',
    'description': 'Build 7-figure ecommerce business',
    'content': 'Build ecommerce business in [NICHE] to $1M+. Include: product selection, supplier sourcing, store setup, branding, product photography, SEO, paid ads, email marketing, conversion optimization, customer service, fulfillment, scaling, and automation. Include business plan and financial projections.',
    'is_premium': 1,
    'difficulty': 'Expert',
    'estimated_time': '45 min',
    'tags': ['ecommerce', 'scaling', 'business']
}
```

### ❌ BAD Prompts

```python
# Too vague
'content': 'Write something about marketing'

# Too short (for premium)
'content': 'Create a business plan'

# Wrong category
'category_id': 'fitness_health'  # for a marketing prompt

# Missing placeholders
'content': 'Create email for my product'  # Should be: 'Create email for [PRODUCT]'
```

---

## Content Writing Tips

### Use Placeholders
```
[TOPIC], [NICHE], [PRODUCT], [SERVICE], [BUSINESS], [GOAL], [AUDIENCE]
```

### Structure for Free Prompts (5-15 min)
```
Action + Context + Key Elements

Example:
"Generate 20 Instagram caption ideas for [NICHE]. Include: hooks, storytelling elements, value propositions, and CTAs that drive engagement."
```

### Structure for Premium Prompts (30-45 min)
```
Goal + Comprehensive Steps + Deliverables

Example:
"Build [BUSINESS TYPE] from $0 to $100K+. Include: [10-15 detailed components]. Create [specific deliverables]."
```

---

## Difficulty Levels

**Beginner** (5-10 min)
- Simple templates
- Quick generators
- Basic frameworks
- Examples: Bio generator, headline ideas, simple outlines

**Intermediate** (10-20 min)
- Moderate complexity
- Multiple steps
- Some strategy
- Examples: Content calendars, project plans, analysis frameworks

**Advanced** (20-35 min)
- Complex strategies
- Multiple components
- Detailed planning
- Examples: Marketing campaigns, business strategies, comprehensive guides

**Expert** (35-45 min)
- Complete systems
- End-to-end solutions
- Scaling strategies
- Examples: Business blueprints, empire builders, mastery frameworks

---

## Premium vs Free Guidelines

### Free Prompts (is_premium: 0)
- Quick wins
- Templates
- Generators
- Simple frameworks
- 5-15 minutes
- Tactical

### Premium Prompts (is_premium: 1)
- Complete systems
- Comprehensive strategies
- Step-by-step blueprints
- Scaling frameworks
- 30-45 minutes
- Strategic

**Ratio:** Aim for 50/50 split (currently 46% premium, 54% free)

---

## Example: Adding 5 Prompts

Edit `ai_add_prompts.py`:

```python
PROMPTS_TO_ADD = [
    {
        'category_id': 'marketing_sales',
        'title': 'Landing Page Headline Generator',
        'description': 'Write converting headlines',
        'content': 'Generate 15 landing page headlines for [OFFER]. Use: benefit-driven, curiosity, urgency, specificity.',
        'is_premium': 0,
        'difficulty': 'Beginner',
        'estimated_time': '5 min',
        'tags': ['landing page', 'headlines', 'conversion']
    },
    {
        'category_id': 'content_creation',
        'title': 'Viral Video Script Formula',
        'description': 'Create viral video scripts',
        'content': 'Write viral video script for [TOPIC]. Include: hook (0-3s), problem (3-15s), solution (15-45s), proof (45-60s), CTA (60-90s). Add visual cues and engagement triggers.',
        'is_premium': 0,
        'difficulty': 'Intermediate',
        'estimated_time': '10 min',
        'tags': ['video', 'script', 'viral']
    },
    {
        'category_id': 'money_making',
        'title': 'Digital Product Launch System',
        'description': 'Launch digital products successfully',
        'content': 'Launch digital product in [NICHE]. Include: product creation, pricing strategy, sales page, email sequences, launch plan, affiliate program, upsells, customer success, and scaling to $50K+/month. Full launch system with templates.',
        'is_premium': 1,
        'difficulty': 'Expert',
        'estimated_time': '45 min',
        'tags': ['digital products', 'launch', 'scaling']
    },
    {
        'category_id': 'freelancing',
        'title': 'Client Proposal Template',
        'description': 'Win more freelance projects',
        'content': 'Create winning proposal for [PROJECT]. Include: project understanding, solution approach, deliverables, timeline, pricing, terms, and next steps.',
        'is_premium': 0,
        'difficulty': 'Intermediate',
        'estimated_time': '10 min',
        'tags': ['proposals', 'clients', 'freelancing']
    },
    {
        'category_id': 'social_media',
        'title': 'Instagram Growth Strategy',
        'description': 'Grow Instagram to 50K followers',
        'content': 'Grow Instagram in [NICHE] to 50K+ followers. Include: content strategy, posting schedule, reel formula, engagement tactics, hashtag strategy, collaboration approach, analytics tracking, and monetization. Complete growth system.',
        'is_premium': 1,
        'difficulty': 'Advanced',
        'estimated_time': '35 min',
        'tags': ['instagram', 'growth', 'followers']
    }
]
```

Then run:
```bash
python ai_add_prompts.py
```

---

## Common Mistakes to Avoid

1. **Wrong category_id** - Use exact IDs from list above
2. **Missing placeholders** - Always use [BRACKETS] for user inputs
3. **Too short for premium** - Premium should be 200+ words
4. **Duplicate titles** - Check existing prompts first
5. **Wrong difficulty** - Match complexity to time estimate
6. **Poor tags** - Use specific, searchable tags

---

## Testing Your Prompts

After adding prompts:

1. **Check stats:**
   ```bash
   python stats.py
   ```

2. **Verify in app:**
   ```bash
   cd ..
   flutter run
   ```

3. **Check categories are balanced** - Add to categories with fewer prompts

---

## Pro Tips

1. **Study existing prompts** - Look at `prompts_database.json` for examples
2. **Focus on value** - What specific problem does it solve?
3. **Be comprehensive** - Premium prompts should be complete systems
4. **Use action verbs** - Generate, Create, Build, Design, Develop
5. **Include deliverables** - What will user have after using prompt?
6. **Balance categories** - Add to categories with <20 prompts first

---

## Quick Reference

**File to edit:** `ai_add_prompts.py`
**Run command:** `python ai_add_prompts.py`
**Check stats:** `python stats.py`
**View database:** `python cli.py` (option 2)

**Current totals:** 504 prompts (232 premium, 272 free)

---

## Need Help?

1. Check `AI_INSTRUCTIONS.txt` for detailed format
2. Look at existing prompts in database
3. Run `python cli.py` to browse prompts
4. Check `stats.py` for category balance

**Remember:** Quality > Quantity. One great prompt is better than 10 mediocre ones!
