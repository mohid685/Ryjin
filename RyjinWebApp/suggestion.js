document.addEventListener('DOMContentLoaded', function() {
    const suggestionForm = document.getElementById('suggestionForm');
    const suggestionBtn = document.getElementById('suggestionBtn');

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