# Import Workflow - Visual Implementation Diagram

## 🔄 Complete Workflow Flow

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   GitHub Node   │───▶│  Markdown Node   │───▶│   HTML Node         │
│   Get File      │    │  Convert to HTML │    │   Extract Categories│
│                 │    │                  │    │                     │
│ Repository:     │    │ Include TOC: No  │    │ Selector: h3        │
│ awesome-prod    │    │ Include Title: No│    │ Return: text[]      │
│ File: readme.md │    │                  │    │ Key: main_category  │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
                                                          │
                                                          ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   Split Node    │◀───│   HTML Node      │    │   HTML Node         │
│ Process Each    │    │ Extract          │    │ Extract             │
│ Category        │    │ Subcategories    │    │ Vendors             │
│                 │    │                  │    │                     │
│ Batch Size: 1   │    │ Selector: h4     │    │ Selector: ul li a   │
│ Include Input:  │    │ Return: text[]   │    │ Return: text[]      │
│ No              │    │ Key: subcategory │    │ Key: vendor_name    │
└─────────────────┘    └──────────────────┘    │ Key: vendor_url     │
         │                        │             │ Key: description    │
         ▼                        ▼             └─────────────────────┘
┌─────────────────┐    ┌──────────────────┐              │
│   Split Node    │    │   Set Node       │              ▼
│ Process Each    │    │ Structure Data   │    ┌─────────────────────┐
│ Subcategory     │    │                  │    │   Set Node          │
│                 │    │ Map to DB Schema │    │ Structure Data      │
│ Batch Size: 1   │    │ Add timestamps   │    │                     │
│ Include Input:  │    │ Set status       │    │ vendor_name:        │
│ No              │    │ Set created_by   │    │ split('[')[1]       │
└─────────────────┘    └──────────────────┘    │ url: vendor_url     │
         │                        │             │ description:        │
         ▼                        ▼             │ split('– ')[1]      │
┌─────────────────┐    ┌──────────────────┐    │ category: from      │
│   HTML Node     │    │ PostgreSQL Node  │    │ Split Category      │
│ Extract Vendors │    │ Batch Insert     │    │ subcategory: from   │
│                 │    │                  │    │ Split Subcategory   │
│ Selector: ul li │    │ Table: vendors   │    │ status: active      │
│ Return: text[]  │    │ Batch Size: 50   │    │ created_by: import  │
│ Key: vendors    │    │ On Conflict:     │    └─────────────────────┘
└─────────────────┘    │ Ignore           │              │
                       └──────────────────┘              ▼
                                │             ┌─────────────────────┐
                                ▼             │ PostgreSQL Node     │
                       ┌──────────────────┐   │ Batch Insert        │
                       │ PostgreSQL Node  │   │                     │
                       │ Verify Count     │   │ Table: vendors      │
                       │                  │   │ Columns: all fields │
                       │ Query: COUNT(*)  │   │ Batch Size: 50      │
                       │ WHERE created_by │   │ On Conflict: Ignore │
                       │ = 'import'       │   └─────────────────────┘
                       └──────────────────┘              │
                                │                       ▼
                                ▼             ┌─────────────────────┐
                       ┌──────────────────┐   │   Set Node          │
                       │   Set Node       │   │ Generate Report     │
                       │ Generate Report  │   │                     │
                       │                  │   │ import_status:      │
                       │ import_status:   │   │ complete            │
                       │ complete         │   │ total_vendors:      │
                       │ total_vendors:   │   │ from Verify Count   │
                       │ from Verify      │   │ import_date: now()  │
                       │ Count            │   │ categories_processed│
                       │ import_date:     │   │ subcategories_proc  │
                       │ now()            │   └─────────────────────┘
                       │ categories_proc  │
                       └──────────────────┘
```

## 🎯 Node Connection Flow

### Main Flow
1. **GitHub** → **Markdown** → **HTML (Categories)**
2. **HTML (Categories)** → **Split (Category)** → **HTML (Subcategories)**
3. **HTML (Subcategories)** → **Split (Subcategory)** → **HTML (Vendors)**
4. **HTML (Vendors)** → **Set (Structure)** → **PostgreSQL (Insert)**
5. **PostgreSQL (Insert)** → **PostgreSQL (Verify)** → **Set (Report)**

### Data Flow Context
```
Category Context: Split Category → HTML Subcategories → Split Subcategory
Subcategory Context: Split Subcategory → HTML Vendors → Set Structure
Vendor Context: Set Structure → PostgreSQL Insert
```

## 🔧 Node Configuration Summary

| Node | Purpose | Key Settings | Expected Output |
|------|---------|--------------|-----------------|
| GitHub | Get File | Repository: Capp3/awesome-production | Raw markdown |
| Markdown | Convert HTML | Include TOC: No | HTML content |
| HTML (Cat) | Extract H3 | Selector: h3, Return: text[] | Category array |
| Split (Cat) | Process Each | Batch Size: 1 | Individual categories |
| HTML (Sub) | Extract H4 | Selector: h4, Return: text[] | Subcategory array |
| Split (Sub) | Process Each | Batch Size: 1 | Individual subcategories |
| HTML (Vend) | Extract UL | Selector: ul li a | Vendor arrays |
| Set | Structure | Map to DB schema | Structured records |
| PostgreSQL | Insert | Batch Size: 50 | Insert results |
| PostgreSQL | Verify | COUNT(*) query | Import count |
| Set | Report | Summary data | Final report |

## 🧪 Testing Points

### Individual Node Testing
- [ ] GitHub node returns valid markdown
- [ ] Markdown node converts to valid HTML
- [ ] HTML nodes extract correct data
- [ ] Split nodes create proper iterations
- [ ] Set nodes structure data correctly
- [ ] PostgreSQL nodes connect and insert

### Integration Testing
- [ ] Category extraction works
- [ ] Subcategory association works
- [ ] Vendor extraction works
- [ ] Data structure mapping works
- [ ] Database insertion works
- [ ] Report generation works

### Full Workflow Testing
- [ ] Complete workflow runs without errors
- [ ] All vendors imported correctly
- [ ] Category associations preserved
- [ ] Database constraints satisfied
- [ ] Import statistics accurate

## 🚨 Common Issues & Solutions

### Issue: HTML Extraction Returns Empty
**Solution**: Check CSS selectors match actual HTML structure
**Debug**: Test selectors with sample HTML content

### Issue: Split Nodes Not Iterating
**Solution**: Verify batch size is set to 1
**Debug**: Check input data format and array structure

### Issue: Database Insertion Fails
**Solution**: Verify table schema and column names
**Debug**: Test database connection and permissions

### Issue: Data Structure Mismatch
**Solution**: Check Set node assignments and expressions
**Debug**: Verify input data format at each node

## 📊 Expected Data Flow

### Input Data
```json
{
  "content": "<h3>Audio</h3><h4>Mixing Consoles</h4><ul><li><a href='...'>Vendor</a> – Description</li></ul>"
}
```

### Category Extraction
```json
{
  "main_category": ["Audio", "Video", "Lighting & Rigging"]
}
```

### Subcategory Extraction
```json
{
  "subcategory": ["Mixing Consoles", "Microphones & IEMs"]
}
```

### Vendor Extraction
```json
{
  "vendor_name": ["Allen & Heath", "Avid"],
  "vendor_url": ["https://www.allen-heath.com/", "https://www.avid.com/"],
  "vendor_description": ["Mixers and control surfaces", "Pro Tools and VENUE systems"]
}
```

### Final Database Record
```json
{
  "vendor_name": "Allen & Heath",
  "url": "https://www.allen-heath.com/",
  "description": "Mixers and control surfaces",
  "category": "Audio",
  "subcategory": "Mixing Consoles",
  "status": "active",
  "date_added": "2024-01-15T10:30:00Z",
  "created_by": "import"
}
```

This visual guide should help you implement the workflow step by step in n8n 1.112.4.
