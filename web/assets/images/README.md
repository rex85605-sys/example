# Photo Gallery

## Instructions

Add your anniversary photos to this directory.

### Recommended Photos
1. **First Date** - A photo from when you first met or your first date
2. **Engagement** - The proposal or engagement celebration
3. **Wedding Day** - Your wedding ceremony or reception
4. **Honeymoon** - A memorable moment from your honeymoon
5. **Recent Photo** - A current photo together

### Image Guidelines
- **Format**: JPG, PNG, or WEBP
- **Size**: Recommended width of 1200-1920px for best quality
- **Aspect Ratio**: 16:9 or 4:3 works best
- **File Size**: Optimize images to keep them under 1MB each for faster loading

### How to Add Photos

1. Copy your photos to this directory
2. Open `index.html` in a text editor
3. Find the slideshow section
4. Replace the placeholder divs with image tags:

```html
<!-- Before (placeholder) -->
<div class="slide active">
    <div class="slide-placeholder">
        <div class="placeholder-icon">📷</div>
        <p class="placeholder-text">First Date</p>
    </div>
</div>

<!-- After (with your photo) -->
<div class="slide active">
    <img src="assets/images/first-date.jpg" alt="Our First Date" style="width: 100%; height: 100%; object-fit: cover;">
</div>
```

### Tips
- Use high-quality photos for the best visual experience
- Make sure photos are properly oriented
- Consider adding captions or alt text for each photo
- Test the slideshow after adding images to ensure smooth transitions
