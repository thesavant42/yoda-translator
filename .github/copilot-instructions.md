# Yoda Translator - AI Coding Agent Instructions

## Project Overview
This is a Python library that translates English text to "Yodish" (Yoda-style speech patterns) using SpaCy for natural language processing. The core architecture follows a pipeline: tokenization → clause chunking → grammar rule application → serialization.

## Architecture & Data Flow
1. **Entry Point**: `yoda.py` - Main translate() function loads SpaCy model and processes input
2. **Text Processing**: `text.py` - Handles sentence splitting, clause chunking, and output serialization
3. **Grammar Rules**: `rules.py` - Contains specific transformation rules that rearrange word order
4. **Word Handling**: `word.py` - Custom Word class with contraction expansion and capitalization logic

**Key Flow**: Raw text → SpaCy tokens → Word objects → Grammar rules → Flattened word list → Formatted string

## Critical Patterns & Conventions

### Grammar Rule System
- Rules in `rules.py` follow pattern: `rule_<pos_tags>(words)` (e.g., `rule_prp_vbp`)
- Each rule uses POS tag sequences to identify and transform patterns
- Rules return `None` if no match, or transformed word list if applied
- All rules applied sequentially via `functools.reduce` in `apply_yodish_grammar()`

### Word Processing
- `Word` class automatically lowercases, expands contractions, and handles capitalization
- Contractions dictionary in `word.py` - Yoda doesn't use contractions
- POS tag-based capitalization: 'I' and proper nouns (NNP) are capitalized

### Text Chunking Strategy
- `split_clauses()` breaks sentences at coordinating conjunctions (`cc`) and punctuation
- Each clause chunk processed independently by grammar rules
- Punctuation preserved as separate Word objects with 'punct' tag

## Development Workflow

### Dependencies
- Uses Poetry for dependency management (`pyproject.toml`)
- SpaCy with `en_core_web_sm` model (installed via direct URL in pyproject.toml)
- Python 3.8+ required

### Testing Approach
- Main functionality demonstrated in `yoda.py` with example: "I sense much anger in him."
- No formal test infrastructure - add tests by running transformations on example sentences

### Adding New Grammar Rules
1. Add rule function to `rules.py` following naming pattern `rule_<pos_pattern>`
2. Use `index_tag_seq()` to find POS tag patterns in word lists
3. Use `move_tag_seq()` or `replace_tag_seq()` helper functions for transformations
4. Add rule to `rules` list in `apply_yodish_grammar()`
5. Test with representative sentences that match the POS pattern

## Key Implementation Details
- POS tag normalization: All noun variants (NN, NNS, NNP) treated as 'NN' in pattern matching
- Punctuation handling: Stop punctuation (. ! ?) triggers capitalization of next word
- Fuzzy tag matching allows rules to work across different noun types
- Rule order matters - earlier rules can affect later rule matching

## Common Debugging Points
- Check SpaCy model loading - ensure `en_core_web_sm` is properly installed
- POS tag mismatches - use `nlp("your text")` to inspect actual tags vs expected
- Word order issues - trace through `apply_yodish_grammar()` rule by rule
- Capitalization problems - verify `Word.apply_capitalization()` logic