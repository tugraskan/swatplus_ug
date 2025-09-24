# SWAT+ Water Allocation System Flowcharts

This repository contains comprehensive flowcharts documenting the SWAT+ water allocation system, designed to help new users understand how the code works.

## Files Included

### 1. `water_allocation_flowchart.md`
**Detailed Technical Flowchart**
- Complete process flow with all subroutines
- Detailed decision points and data flow
- Comprehensive module and type documentation
- Input/output file specifications
- Best for: Developers, advanced users, complete system understanding

### 2. `water_allocation_poster_flowchart.md`
**Poster-Ready Simplified Flowchart**
- Streamlined process flow for presentations
- Key subroutines highlighted
- Essential information condensed
- Clean visual layout
- Best for: Conference posters, presentations, quick overview

### 3. `water_allocation_visual_guide.md`
**New User Visual Guide**
- Beginner-friendly explanations
- Compact diagrams with clear annotations
- Data flow architecture
- Component explanations
- Best for: New users, training materials, introductory documentation

## How to Use These Flowcharts

### For Poster Presentations
1. Use `water_allocation_poster_flowchart.md` as your primary source
2. The mermaid diagram can be rendered using:
   - GitHub (automatic rendering)
   - Mermaid Live Editor (https://mermaid.live/)
   - VSCode with Mermaid extensions
   - Markdown editors with Mermaid support

### For Documentation
1. Use `water_allocation_flowchart.md` for comprehensive documentation
2. Include relevant sections in technical reports
3. Reference specific subroutines and their relationships

### For Training New Users
1. Start with `water_allocation_visual_guide.md`
2. Use the component explanations and examples
3. Progress to more detailed flowcharts as understanding develops

## Rendering Flowcharts

### Online Tools
- **Mermaid Live Editor**: https://mermaid.live/
  - Copy/paste the mermaid code
  - Export as PNG, SVG, or PDF
- **GitHub**: Automatically renders mermaid in markdown files

### Local Tools
- **VSCode Extensions**:
  - Markdown Preview Mermaid Support
  - Mermaid Markdown Syntax Highlighting
- **Pandoc**: Convert markdown to various formats
- **GitLab**: Native mermaid support in markdown

### Command Line
```bash
# Install mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Convert to image
mmdc -i water_allocation_poster_flowchart.md -o flowchart.png
mmdc -i water_allocation_poster_flowchart.md -o flowchart.svg
```

## Key Features Documented

### Subroutines Covered
- `water_allocation_read()` - Input file processing
- `header_water_allocation()` - Output file setup
- `wallo_control()` - Main allocation control
- `wallo_demand()` - Demand calculation
- `wallo_withdraw()` - Water extraction
- `wallo_transfer()` - Water movement
- `wallo_treatment()` - Water treatment
- `water_allocation_output()` - Results writing

### Modules Documented
- `water_allocation_module` - Core data structures
- `hydrograph_module` - Water flow management
- `hru_module` - Hydrologic Response Units
- `reservoir_module` - Reservoir operations
- `aquifer_module` - Groundwater management

### Data Types Explained
- `water_allocation` - Main allocation object
- `water_source_objects` - Source definitions
- `water_demand_objects` - Demand specifications
- `hyd_output` - Hydrograph data structure

### Process Flow Elements
1. **Initialization**: File reading and setup
2. **Daily Processing**: Demand calculation and allocation
3. **Water Withdrawal**: Source-specific extraction rules
4. **Transfer & Treatment**: Movement and quality management
5. **Output Generation**: Results reporting

## Customization

### For Different Audiences
- **Developers**: Use detailed flowchart with all subroutines
- **Managers**: Use poster flowchart focusing on process overview
- **Students**: Use visual guide with explanations and examples

### For Specific Applications
- **Irrigation Focus**: Emphasize HRU and crop demand sections
- **Municipal Water**: Highlight urban demand and treatment processes
- **Water Rights**: Focus on priority and allocation rule sections

## Integration with SWAT+ Documentation

These flowcharts complement existing SWAT+ documentation by:
- Providing visual representation of code structure
- Clarifying subroutine relationships and calling sequences
- Documenting input/output file formats and timing
- Explaining decision points and data flow

## Updates and Maintenance

When modifying the water allocation code:
1. Update relevant flowchart sections
2. Verify subroutine calling sequences
3. Check input/output file specifications
4. Update module and type documentation
5. Test flowchart rendering in target formats

## Contact and Contributions

These flowcharts are designed to be living documents that evolve with the SWAT+ water allocation system. Updates and improvements are welcome to keep them current and useful for the user community.