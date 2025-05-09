document.addEventListener('DOMContentLoaded', function() {
    const suggestionForm = document.getElementById('suggestionForm');
    const suggestionBtn = document.getElementById('suggestionBtn');

    // Add GT-R themed styles
    const style = document.createElement('style');
    style.textContent = `
        #suggestionModal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.85);
            backdrop-filter: blur(8px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        #suggestionModal:not(.hidden) {
            opacity: 1;
            visibility: visible;
        }

        .modal-content {
            background: linear-gradient(145deg, rgba(20,20,20,0.95), rgba(12,12,12,0.98));
            border-radius: 12px;
            padding: 2.5rem;
            width: 90%;
            max-width: 500px;
            position: relative;
            transform: translateY(20px);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid var(--gtr-red);
            box-shadow: 0 20px 40px rgba(0,0,0,0.5), 0 0 30px var(--gtr-glow);
        }

        #suggestionModal:not(.hidden) .modal-content {
            transform: translateY(0);
        }

        .modal-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, transparent, var(--gtr-red), transparent);
            box-shadow: 0 0 15px var(--gtr-red);
        }

        .modal-header {
            margin-bottom: 2rem;
            text-align: center;
        }

        .modal-header h2 {
            font-family: 'Orbitron', sans-serif;
            font-size: 2rem;
            color: var(--gtr-red);
            text-transform: uppercase;
            letter-spacing: 3px;
            margin-bottom: 1rem;
            text-shadow: 0 0 15px var(--gtr-red);
        }

        .modal-header p {
            color: var(--text-secondary);
            font-family: 'Rajdhani', sans-serif;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
            font-family: 'Rajdhani', sans-serif;
            font-size: 1.1rem;
            letter-spacing: 1px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 1rem 1.25rem;
            background: rgba(20,20,20,0.8);
            border: 1px solid rgba(255,0,51,0.3);
            border-radius: 8px;
            color: var(--text-primary);
            font-family: 'Rajdhani', sans-serif;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: inset 0 2px 8px rgba(0,0,0,0.3);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--gtr-red);
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.2), 0 0 15px var(--gtr-glow);
            transform: translateY(-2px);
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.85rem 2rem;
            border-radius: 8px;
            font-family: 'Orbitron', sans-serif;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: none;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: transform 0.6s ease;
        }

        .btn:hover::before {
            transform: translateX(200%);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--gtr-red-dark), var(--gtr-red));
            color: white;
            box-shadow: 0 4px 20px rgba(255,0,51,0.5);
            border: 1px solid var(--gtr-red);
        }

        .btn-primary:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 30px var(--gtr-glow);
            background: linear-gradient(135deg, var(--gtr-red), var(--gtr-red-dark));
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--gtr-red);
            color: var(--gtr-red);
            box-shadow: 0 0 10px rgba(255,0,51,0.2);
        }

        .btn-outline:hover {
            background: rgba(255,0,51,0.1);
            box-shadow: 0 0 20px var(--gtr-glow);
        }

        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: none;
            border: none;
            color: var(--text-secondary);
            font-size: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .close-btn:hover {
            color: var(--gtr-red);
            background: rgba(255,0,51,0.1);
            transform: rotate(90deg);
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
    `;
    document.head.appendChild(style);

    if (suggestionForm && suggestionBtn) {
        // Set the correct form action with full URL
        const baseUrl = window.location.origin;
        const contextPath = window.location.pathname.split('/')[1] || '';
        const servletUrl = `${baseUrl}/${contextPath}/suggestion`;
        suggestionForm.action = servletUrl;
        suggestionForm.method = 'post';
        console.log('Form action set to:', suggestionForm.action);

        // Handle modal toggle
        suggestionBtn.addEventListener('click', function() {
            toggleSuggestionModal();
        });

        // Handle form submission
        suggestionForm.addEventListener('submit', function(e) {
            const suggestionInput = document.getElementById('suggestion');
            const suggestionValue = suggestionInput.value.trim();

            if (suggestionValue) {
                // Let the form submit naturally to the servlet URL
                return true;
            } else {
                e.preventDefault();
                alert('Please enter a suggestion before submitting');
            }
        });
    }
});

function toggleSuggestionModal() {
    const modal = document.getElementById('suggestionModal');
    if (modal) {
        modal.classList.toggle('hidden');
        if (!modal.classList.contains('hidden')) {
            document.getElementById('suggestion').focus();
        }
    }
}

window.toggleSuggestionModal = toggleSuggestionModal;