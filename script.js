// ===== Scroll Animations =====
document.addEventListener('DOMContentLoaded', () => {
    // Add fade-up class to animatable elements
    const animatableSelectors = [
        '.benefit-card',
        '.step',
        '.hero-content',
        '.cta-content',
        '.section-tag',
        '.benefits h2',
        '.process h2',
        '.section-subtitle'
    ];

    animatableSelectors.forEach(selector => {
        document.querySelectorAll(selector).forEach(el => {
            el.classList.add('fade-up');
        });
    });

    // Intersection Observer for scroll animations
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry, index) => {
            if (entry.isIntersecting) {
                // Add staggered delay for grid items
                const delay = entry.target.closest('.benefits-grid') || entry.target.closest('.steps')
                    ? index * 100
                    : 0;
                
                setTimeout(() => {
                    entry.target.classList.add('visible');
                }, delay);
                
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.15,
        rootMargin: '0px 0px -50px 0px'
    });

    document.querySelectorAll('.fade-up').forEach(el => {
        observer.observe(el);
    });

    // Smooth parallax effect on hero
    const hero = document.querySelector('.hero');
    const heroBg = document.querySelector('.hero-bg-overlay');
    
    window.addEventListener('scroll', () => {
        if (hero) {
            const scrolled = window.pageYOffset;
            const rate = scrolled * 0.3;
            if (heroBg) {
                heroBg.style.transform = `translateY(${rate}px)`;
            }
        }
    }, { passive: true });
});
