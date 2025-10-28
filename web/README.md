# Wedding Anniversary Website for Akku ❤️

A beautiful, romantic wedding anniversary website with photo slideshow, timeline, wishes, and background music.

## Features

### 🎵 Background Music Player
- Play/pause controls in the top-right corner
- Loops continuously when playing
- Elegant floating button design

### 📸 Photo Slideshow
- Smooth transitions between photos
- Auto-advance every 5 seconds
- Manual navigation with previous/next buttons
- Dot indicators for current slide
- Touch swipe support on mobile devices
- Keyboard navigation (arrow keys)

### 📖 Love Story Timeline
- Beautifully styled timeline layout
- Key moments from the relationship
- Hover effects and animations
- Responsive design that adapts to mobile

### 💌 Special Wishes Section
- Grid of romantic message cards
- Icon decorations
- Hover animations
- Fully responsive layout

## Design Features

- **Color Palette**: Soft pinks, roses, and golds for a romantic feel
- **Typography**: Elegant fonts including Great Vibes, Playfair Display, and Poppins
- **Animations**: Smooth transitions, floating hearts, parallax effects
- **Responsive**: Works perfectly on desktop, tablet, and mobile devices
- **Accessibility**: ARIA labels and keyboard navigation support

## Setup Instructions

### Adding Photos
1. Place your photos in the `assets/images/` directory
2. Update the slideshow HTML in `index.html` to reference your images
3. Replace the placeholder divs with `<img>` tags:
   ```html
   <div class="slide active">
       <img src="assets/images/your-photo.jpg" alt="Description">
   </div>
   ```

### Adding Music
1. Place your romantic background music file in `assets/music/`
2. Supported formats: MP3, WAV, OGG
3. The file should be named `romantic.mp3` or update the reference in `index.html`
4. Recommended: Use a soft instrumental romantic track

### Customization

#### Change Colors
Edit the CSS variables in `styles.css`:
```css
:root {
    --primary-color: #ff6b9d;
    --secondary-color: #ffc1e3;
    --accent-color: #f8b500;
    /* ... */
}
```

#### Update Timeline Events
Edit the timeline section in `index.html` to match your own story milestones.

#### Modify Wishes
Edit the wishes grid section in `index.html` to add your own personal messages.

## Browser Compatibility

- Chrome (recommended)
- Firefox
- Safari
- Edge
- Mobile browsers (iOS Safari, Chrome Mobile)

## File Structure

```
web/
├── index.html          # Main HTML file
├── styles.css          # All styling and animations
├── script.js           # Interactive functionality
├── README.md           # This file
└── assets/
    ├── images/         # Place photos here
    └── music/          # Place background music here
```

## Usage

Simply open `index.html` in a web browser, or host it on any web server.

To run locally:
1. Navigate to the `web` directory
2. Open `index.html` in your browser
3. Or use a local server: `python -m http.server 8000`

## Credits

Made with ❤️ for Akku's Anniversary

## Notes

- The website works offline once loaded
- Music autoplay might be blocked by some browsers until user interaction
- Photos are placeholders - add your own special moments!
- All animations are CSS-based for smooth performance
