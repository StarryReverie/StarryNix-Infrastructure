const fireworksContainer = document.getElementById('fireworks-container');
const colors = [
    '#FF6B6B',
	  '#4ECDC4',
	  '#45B7D1',
	  '#FFA07A',
	  '#98D8C8',
	  '#F7DC6F',
	  '#D7BDE2',
	  '#58D68D',
	  '#85C1E9',
	  '#FFD166'
];

function createFirework() {
    const startX = Math.random() * window.innerWidth;
    const startY = window.innerHeight;

    const explosionY = Math.random() * window.innerHeight * 0.7;

    const color = colors[Math.floor(Math.random() * colors.length)];

    const rocket = document.createElement('div');
    rocket.className = 'firework';
    rocket.style.left = `${startX}px`;
    rocket.style.top = `${startY}px`;
    rocket.style.backgroundColor = color;
    rocket.style.boxShadow = `0 0 10px 2px ${color}`;
    fireworksContainer.appendChild(rocket);

    const rocketAnimation = rocket.animate([
        { transform: 'translateY(0)', opacity: 1 },
        { transform: `translateY(-${startY - explosionY}px)`, opacity: 1 }
    ], {
        duration: 800 + Math.random() * 1200,
        easing: 'cubic-bezier(0.25, 1, 0.5, 1)'
    });

    rocketAnimation.onfinish = () => {
        rocket.remove();

        const particleCount = 80 + Math.floor(Math.random() * 70);
        for (let i = 0; i < particleCount; i++) {
            const particle = document.createElement('div');
            particle.className = 'firework';
            particle.style.left = `${startX}px`;
            particle.style.top = `${explosionY}px`;
            particle.style.backgroundColor = color;
            particle.style.boxShadow = `0 0 6px 1px ${color}`;

            const angle = Math.random() * Math.PI * 2;
            const distance = 40 + Math.random() * 120;
            const endX = Math.cos(angle) * distance;
            const endY = Math.sin(angle) * distance;

            fireworksContainer.appendChild(particle);

            // Animate particle explosion
            const particleAnimation = particle.animate([
                { transform: 'translate(0, 0)', opacity: 1 },
                { transform: `translate(${endX}px, ${endY}px)`, opacity: 0 }
            ], {
                duration: 1000 + Math.random() * 500,
                easing: 'cubic-bezier(0.1, 0.8, 0.9, 1)'
            });

            particleAnimation.onfinish = () => {
                particle.remove();
            };
        }
    };
}

function startFireworks() {
    for (let i = 0; i < 12; i++) {
        setTimeout(createFirework, i * 300);
    }

    setInterval(() => {
        createFirework();
        if (Math.random() > 0.3) {
            createFirework();
        }
    }, 500 + Math.random() * 500);
}

window.addEventListener('load', startFireworks);
