# Python Code Node Fix Summary

## Issue

The Python Code (Beta) node in n8n 1.115.3 was returning the error:

```
"errorMessage": "Code doesn't return items properly"
"errorDescription": "Please return an array of dictionaries, one for each item you would like to output."
```

## Root Cause

The Python code was not following n8n's Python Code node standards:

1. Using `items[0]` instead of `_input.all()[0]`
2. Using `def main():` wrapper (not needed)
3. Incorrect indentation due to function wrapper

## Solution Applied

### Before (Incorrect):

```python
def main():
    html_content = items[0]['json']['content']
    # ... rest of code
    return [{'json': vendor} for vendor in vendors]
```

### After (Correct):

```python
# Get HTML content from previous node using n8n's _input helper
input_items = _input.all()
html_content = input_items[0]['json']['content']
# ... rest of code
# Return all vendors as separate items for n8n
return [{'json': vendor} for vendor in vendors]
```

## Key Changes

1. **Input Access**: Changed from `items[0]` to `_input.all()[0]`
   - n8n Python Code node uses `_input.all()` to access input items
2. **No Function Wrapper**: Removed `def main():`
   - Python Code node executes script at top level
   - No function definition needed
3. **Fixed Indentation**: Adjusted all code to top-level indentation
4. **Return Format**: Kept `[{'json': vendor} for vendor in vendors]`
   - Each item must be a dict with 'json' key
   - This is correct format for n8n

## n8n Python Code Node Standards

### Input Access

```python
# Access all input items
input_items = _input.all()

# Access specific item
first_item = input_items[0]
data = first_item['json']
```

### Return Format

```python
# Must return list of dicts, each with 'json' key
return [
    {'json': {'field1': 'value1', 'field2': 'value2'}},
    {'json': {'field1': 'value3', 'field2': 'value4'}}
]
```

### No Function Wrapper

```python
# INCORRECT - Do not use def main()
def main():
    return results

# CORRECT - Execute at top level
results = process_data()
return results
```

## Documentation Updates

- Updated `workflows/01-import-workflow.md` with:
  - Correct Python code
  - Node settings (Language: Python, Mode: Run Once for All Items)
  - Key points explaining n8n standards
- Updated `workflows/json/AwesomeVacum.json` with fixed Python code

## Additional Improvements

### Table of Contents Filtering

Added validation to exclude table of contents entries:

- Skip links starting with # (markdown anchor links)
- Only process entries with valid HTTP/HTTPS URLs
- Prevents ToC entries from being imported as vendors

Code added:

```python
# Skip table of contents entries (markdown anchors start with #)
if vendor_url.startswith('#'):
    continue

# Skip entries without valid URLs (must contain http:// or https://)
if not vendor_url or not (vendor_url.startswith('http://') or vendor_url.startswith('https://')):
    continue
```

## References

- n8n Documentation: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.code/
- n8n Community: https://community.n8n.io/t/code-node-python-error-code-doesnt-return-items-properly/29729

## Status

✅ **Fixed and Ready for Testing**
✅ **ToC Filtering Added**

**NOTE**: This document is archived. Implementation complete. Details are now in `workflows/01-import-workflow.md`.

