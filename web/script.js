// Music Player Functionality
const musicToggle = document.getElementById('musicToggle');
const backgroundMusic = document.getElementById('backgroundMusic');
const playIcon = document.querySelector('.play-icon');
const pauseIcon = document.querySelector('.pause-icon');

let isPlaying = false;

musicToggle.addEventListener('click', () => {
    if (isPlaying) {
        backgroundMusic.pause();
        playIcon.classList.remove('hidden');
        pauseIcon.classList.add('hidden');
    } else {
        backgroundMusic.play().catch(err => {
            console.log('Audio playback failed:', err);
        });
        playIcon.classList.add('hidden');
        pauseIcon.classList.remove('hidden');
    }
    isPlaying = !isPlaying;
});

// Slideshow Functionality
const slides = document.querySelectorAll('.slide');
const prevBtn = document.querySelector('.slide-btn.prev');
const nextBtn = document.querySelector('.slide-btn.next');
const dotsContainer = document.querySelector('.slide-dots');

let currentSlide = 0;
const totalSlides = slides.length;
let slideInterval;

// Create dots
for (let i = 0; i < totalSlides; i++) {
    const dot = document.createElement('span');
    dot.classList.add('dot');
    if (i === 0) dot.classList.add('active');
    dot.addEventListener('click', () => goToSlide(i));
    dotsContainer.appendChild(dot);
}

const dots = document.querySelectorAll('.dot');

function showSlide(index) {
    slides.forEach(slide => slide.classList.remove('active'));
    dots.forEach(dot => dot.classList.remove('active'));
    
    slides[index].classList.add('active');
    dots[index].classList.add('active');
}

function nextSlide() {
    currentSlide = (currentSlide + 1) % totalSlides;
    showSlide(currentSlide);
}

function prevSlide() {
    currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
    showSlide(currentSlide);
}

function goToSlide(index) {
    currentSlide = index;
    showSlide(currentSlide);
    resetInterval();
}

function resetInterval() {
    clearInterval(slideInterval);
    slideInterval = setInterval(nextSlide, 5000);
}

// Event listeners
nextBtn.addEventListener('click', () => {
    nextSlide();
    resetInterval();
});

prevBtn.addEventListener('click', () => {
    prevSlide();
    resetInterval();
});

// Auto-play slideshow
slideInterval = setInterval(nextSlide, 5000);

// Keyboard navigation
document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowLeft') {
        prevSlide();
        resetInterval();
    } else if (e.key === 'ArrowRight') {
        nextSlide();
        resetInterval();
    }
});

// Intersection Observer for scroll animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe timeline items
document.querySelectorAll('.timeline-item').forEach((item, index) => {
    item.style.opacity = '0';
    item.style.transform = 'translateY(30px)';
    item.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
    observer.observe(item);
});

// Observe wish cards
document.querySelectorAll('.wish-card').forEach((card, index) => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(30px)';
    card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
    observer.observe(card);
});

// Touch swipe support for mobile
let touchStartX = 0;
let touchEndX = 0;

const slideshowWrapper = document.querySelector('.slideshow-wrapper');

slideshowWrapper.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
});

slideshowWrapper.addEventListener('touchend', (e) => {
    touchEndX = e.changedTouches[0].screenX;
    handleSwipe();
});

function handleSwipe() {
    const swipeThreshold = 50;
    const diff = touchStartX - touchEndX;
    
    if (Math.abs(diff) > swipeThreshold) {
        if (diff > 0) {
            nextSlide();
        } else {
            prevSlide();
        }
        resetInterval();
    }
}

// Smooth scroll for navigation
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Add parallax effect to hero section
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const hero = document.querySelector('.hero-content');
    const floatingHearts = document.querySelector('.floating-hearts');
    
    if (hero && scrolled < window.innerHeight) {
        hero.style.transform = `translateY(${scrolled * 0.5}px)`;
        hero.style.opacity = 1 - (scrolled / window.innerHeight);
    }
    
    if (floatingHearts && scrolled < window.innerHeight) {
        floatingHearts.style.transform = `translateY(${scrolled * 0.3}px)`;
    }
});

// Prevent context menu on music button (optional UX enhancement)
musicToggle.addEventListener('contextmenu', (e) => {
    e.preventDefault();
});

// Log when page is ready
console.log('Anniversary website loaded! 💕');
