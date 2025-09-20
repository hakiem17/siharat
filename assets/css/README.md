# SI-HARAT CSS Theme Documentation

## Overview
SI-HARAT menggunakan sistem CSS custom yang konsisten dan modern untuk memastikan tampilan yang seragam di seluruh aplikasi.

## File Structure
```
assets/css/
├── siharat-theme.css      # Main theme (full version)
├── siharat-landing.css    # Landing page specific styles
├── siharat-min.css        # Minified version for production
└── README.md             # This documentation
```

## Color Palette

### Primary Colors
- **Primary**: `#2c5aa0` (SI-HARAT Blue)
- **Primary Dark**: `#1e3d6f`
- **Primary Light**: `#4a7bc8`

### Secondary Colors
- **Secondary**: `#28a745` (Success Green)
- **Secondary Dark**: `#1e7e34`
- **Secondary Light**: `#34ce57`

### Accent Colors
- **Accent**: `#ffc107` (Warning Yellow)
- **Accent Dark**: `#e0a800`
- **Accent Light**: `#ffcd39`

### Status Colors
- **Success**: `#28a745`
- **Warning**: `#ffc107`
- **Danger**: `#dc3545`
- **Info**: `#17a2b8`

## Typography

### Font Family
```css
font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
```

### Font Weights
- **Normal**: 400
- **Medium**: 500
- **Semibold**: 600
- **Bold**: 700

## Components

### Buttons
```html
<!-- Primary Button -->
<button class="btn-siharat btn-siharat-primary">Primary Action</button>

<!-- Secondary Button -->
<button class="btn-siharat btn-siharat-secondary">Secondary Action</button>

<!-- Outline Button -->
<button class="btn-siharat btn-siharat-outline">Outline Button</button>
```

### Cards
```html
<!-- Basic Card -->
<div class="card-siharat">
    <div class="card-siharat-header">
        <h3>Card Title</h3>
    </div>
    <div class="card-siharat-body">
        <p>Card content goes here</p>
    </div>
    <div class="card-siharat-footer">
        <button class="btn-siharat btn-siharat-primary">Action</button>
    </div>
</div>
```

### Stats Cards
```html
<!-- Stats Card -->
<div class="stats-card">
    <div class="stats-card-icon primary">
        <i class="fas fa-users"></i>
    </div>
    <div class="stats-card-title">Total Users</div>
    <div class="stats-card-value">1,234</div>
    <div class="stats-card-change positive">+12%</div>
</div>
```

### Forms
```html
<!-- Form Input -->
<div class="form-group">
    <label class="form-label-siharat">Label</label>
    <input type="text" class="form-control-siharat" placeholder="Enter text">
</div>
```

### Tables
```html
<!-- Table -->
<table class="table-siharat">
    <thead>
        <tr>
            <th>Header 1</th>
            <th>Header 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Data 1</td>
            <td>Data 2</td>
        </tr>
    </tbody>
</table>
```

### Alerts
```html
<!-- Success Alert -->
<div class="alert-siharat alert-siharat-success">
    <i class="fas fa-check-circle"></i>
    Success message
</div>

<!-- Warning Alert -->
<div class="alert-siharat alert-siharat-warning">
    <i class="fas fa-exclamation-triangle"></i>
    Warning message
</div>

<!-- Danger Alert -->
<div class="alert-siharat alert-siharat-danger">
    <i class="fas fa-times-circle"></i>
    Error message
</div>
```

### Badges
```html
<!-- Badges -->
<span class="badge-siharat badge-siharat-primary">Primary</span>
<span class="badge-siharat badge-siharat-secondary">Secondary</span>
<span class="badge-siharat badge-siharat-success">Success</span>
<span class="badge-siharat badge-siharat-warning">Warning</span>
<span class="badge-siharat badge-siharat-danger">Danger</span>
```

## Utility Classes

### Colors
```css
.text-primary     /* Primary text color */
.text-secondary   /* Secondary text color */
.text-accent      /* Accent text color */
.bg-gradient-primary    /* Primary gradient background */
.bg-gradient-secondary  /* Secondary gradient background */
```

### Shadows
```css
.shadow-siharat      /* Standard shadow */
.shadow-siharat-lg   /* Large shadow */
```

### Border Radius
```css
.border-radius-siharat     /* Standard border radius */
.border-radius-siharat-lg  /* Large border radius */
```

### Text Gradient
```css
.text-gradient  /* Gradient text effect */
```

## Responsive Design

### Breakpoints
- **Mobile**: < 576px
- **Tablet**: 576px - 768px
- **Desktop**: > 768px

### Mobile Optimizations
- Full-width buttons on mobile
- Reduced padding and margins
- Optimized font sizes
- Touch-friendly interface

## Animations

### Fade In
```css
.fade-in  /* Fade in animation */
```

### Slide In
```css
.slide-in-left   /* Slide in from left */
.slide-in-right  /* Slide in from right */
```

### Pulse
```css
.pulse  /* Pulse animation */
```

## Usage Examples

### Dashboard Layout
```html
<div class="row">
    <div class="col-md-3">
        <div class="stats-card">
            <div class="stats-card-icon primary">
                <i class="fas fa-users"></i>
            </div>
            <div class="stats-card-title">Total Users</div>
            <div class="stats-card-value">1,234</div>
            <div class="stats-card-change positive">+12%</div>
        </div>
    </div>
</div>
```

### Landing Page Hero
```html
<section class="hero-siharat">
    <div class="container">
        <h1 class="text-gradient-siharat">SI-HARAT</h1>
        <p>System Information Human Resource & Administrasi Terpadu</p>
        <a href="#" class="btn-siharat-landing">
            <i class="fas fa-rocket"></i>
            Get Started
        </a>
    </div>
</section>
```

## Performance Tips

1. **Use Minified Version**: Use `siharat-min.css` for production
2. **Critical CSS**: Include critical styles inline for faster loading
3. **Lazy Loading**: Load non-critical styles asynchronously
4. **Purge Unused**: Remove unused CSS classes in production

## Browser Support

- Chrome 60+
- Firefox 60+
- Safari 12+
- Edge 79+

## Customization

### Override Variables
```css
:root {
    --siharat-primary: #your-color;
    --siharat-secondary: #your-color;
}
```

### Custom Components
```css
.your-custom-component {
    /* Use SI-HARAT variables */
    background: var(--siharat-primary);
    color: white;
    border-radius: var(--siharat-border-radius);
    padding: var(--siharat-spacing-md);
}
```

## Best Practices

1. **Consistent Spacing**: Use CSS variables for consistent spacing
2. **Color Harmony**: Stick to the defined color palette
3. **Typography**: Use the defined font family and weights
4. **Responsive**: Always test on different screen sizes
5. **Accessibility**: Ensure proper contrast ratios
6. **Performance**: Minimize CSS for faster loading

## Support

For questions or issues with the SI-HARAT CSS theme, please refer to the main documentation or contact the development team.
