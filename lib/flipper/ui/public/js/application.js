document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function(el) {
    new bootstrap.Tooltip(el)
  })

  document.querySelectorAll(".js-toggle-trigger").forEach(function (trigger) {
    trigger.addEventListener("click", function () {
      var container = this.closest(".js-toggle-container");
      container.classList.toggle("toggle-on");
    });
  });

  document.querySelectorAll("*[data-confirmation-text]").forEach(function (element) {
    element.addEventListener("click", function (e) {
      var expected = e.target.getAttribute("data-confirmation-text");
      var actual = prompt(e.target.getAttribute("data-confirmation-prompt"));

      if (expected !== actual) {
        e.preventDefault();
      }
    });
  });

   document.querySelectorAll(".js-add-expression").forEach(function (button) {
     button.addEventListener("click", function () {
        var form = button.closest("form");

        if (button.dataset.root && form.querySelector(".expression")) {
          return;
        }

        var template = document.querySelector("#expression");
        var clone = template.content.cloneNode(true);

        var expressionsContainer = form.querySelector(".expressions");
        expressionsContainer.appendChild(clone);

        var expressions = form.querySelectorAll(".expression")
        var expressionCount = expressions.length
        var expression = expressions[expressionCount - 1];

        var removeButton = expression.querySelector(".js-remove-expression");
        var tooltip = new bootstrap.Tooltip(removeButton);

        removeButton.addEventListener("click", function () {
          tooltip.dispose();
          expression.remove();
          button.disabled = false;
        });

        button.disabled = true;
      });
   });
});
