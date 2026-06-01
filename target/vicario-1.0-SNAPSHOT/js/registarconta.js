'use strict';

$(function() {
    $(document).on("submit", ".form_criar", function (event) {
        var form = $(this);
        var email = $("#email").val();
        var isValid = true;

        if (!validateEmail(email)) {
            isValid = false;
            $("#email-error").show().text('Por favor insira um email válido.');
            $("#email").addClass("input-error");
        } else {
            $("#email-error").hide();
            $("#email").removeClass("input-error");
        }

        if (!isValid) {
            event.preventDefault();
            event.stopPropagation();
        }

        form.addClass('was-validated');
    });

    function validateEmail(email) {
        var regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return regex.test(email);
    }
});
