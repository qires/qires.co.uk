(function () {
    var btn = document.getElementById('menu-btn');
    var menu = document.getElementById('mobile-menu');
    if (!btn || !menu) return;

    function setOpen(open) {
        menu.hidden = !open;
        btn.setAttribute('aria-expanded', String(open));
        btn.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
        btn.classList.toggle('is-open', open);
    }

    btn.addEventListener('click', function () {
        setOpen(menu.hidden);
    });

    menu.addEventListener('click', function (e) {
        if (e.target.closest('a')) setOpen(false);
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && !menu.hidden) {
            setOpen(false);
            btn.focus();
        }
    });
})();

/* Reveal sections as they scroll into view */
(function () {
    var items = document.querySelectorAll('.fade-in');
    if (!items.length) return;

    if (!('IntersectionObserver' in window) ||
        window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
        items.forEach(function (el) { el.classList.add('is-visible'); });
        return;
    }

    var io = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
                io.unobserve(entry.target);
            }
        });
    }, { rootMargin: '0px 0px -10% 0px' });

    items.forEach(function (el) { io.observe(el); });
})();

/* Mark the rail link for the section currently in view */
(function () {
    var links = document.querySelectorAll('.rail-link');
    if (!links.length || !('IntersectionObserver' in window)) return;

    var byId = {};
    var targets = [];
    links.forEach(function (link) {
        var id = (link.getAttribute('href') || '').split('#')[1];
        var section = id && document.getElementById(id);
        if (!section) return;
        byId[id] = link;
        targets.push(section);
    });

    var visible = {};
    var io = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            visible[entry.target.id] = entry.isIntersecting;
        });
        var current = null;
        targets.forEach(function (section) {
            if (visible[section.id] && !current) current = section.id;
        });
        links.forEach(function (link) { link.removeAttribute('aria-current'); });
        if (current) byId[current].setAttribute('aria-current', 'true');
    }, { rootMargin: '-25% 0px -60% 0px' });

    targets.forEach(function (section) { io.observe(section); });
})();
