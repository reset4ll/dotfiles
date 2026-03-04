// ==UserScript==
// @name         GitHub Commit Timestamp
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Inserta timestamp en commits de GitHub con Ctrl+Shift+T
// @author       admin
// @match        https://github.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    document.addEventListener('keydown', function(e) {
        // Atajo: Ctrl+Shift+T
        if (e.ctrlKey && e.shiftKey && e.key === 'T') {
            const now = new Date();
            const timestamp = now.toISOString().slice(0, 19).replace('T', ' ');
            const formatted = `<${timestamp}> `;

            const activeEl = document.activeElement;

            if (activeEl && (activeEl.tagName === 'TEXTAREA' || activeEl.tagName === 'INPUT')) {
                const start = activeEl.selectionStart;
                const end = activeEl.selectionEnd;
                const text = activeEl.value;

                activeEl.value = text.slice(0, start) + formatted + text.slice(end);
                activeEl.selectionStart = activeEl.selectionEnd = start + formatted.length;

                // Trigger events para que GitHub detecte el cambio
                activeEl.dispatchEvent(new Event('input', { bubbles: true }));
                activeEl.dispatchEvent(new Event('change', { bubbles: true }));

                e.preventDefault();
            }
        }
    });
})();