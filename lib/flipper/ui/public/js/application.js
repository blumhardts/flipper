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

  document.addEventListener("click", function (e) {
    // Add new expression
    if (e.target.classList.contains("js-add-expression")) {
      // Clone expression template and insert it before the expression controls
      var expressionTemplate = document.querySelector("#expression");
      var expression = expressionTemplate.content.cloneNode(true);
      var expressions = e.target.closest(".expressions");
      var expressionControls = expressions.querySelector(".expression-controls");

      expressions.insertBefore(expression, expressionControls);

      // Initialize remove button tooltip
      var removeExpressionButton = expressions.querySelector(".js-remove-expression");
      new bootstrap.Tooltip(removeExpressionButton);

      // Remove root expression controls if there's only one expression in the
      // form and it's not in an expression group
      var form = expressions.closest("form");
      var expressionsCount = form.querySelectorAll(".expression").length;
      var expressionGroup = form.querySelector(".expression-group");

      if (expressionsCount === 1 && !expressionGroup) {
        e.target.closest(".expression-controls").remove();
      }
    }

    // Add new expression group
    if (e.target.classList.contains("js-add-expression-group")) {
      // Clone expression group template and insert it before the expression controls
      var template = document.querySelector("#expression-group");
      var expressionGroup = template.content.cloneNode(true);
      var expressions = e.target.closest(".expressions");

      var groupType = e.target.dataset.groupType;
      var expressionGroupTitle = expressionGroup.querySelector(".badge");
      expressionGroupTitle.textContent = groupType;

      expressions.appendChild(expressionGroup);

      // Remove root expression controls if there's only one expression group
      // in the form
      var form = expressions.closest("form");
      var expressionGroupsCount =
        form.querySelectorAll(".expression-group").length;

      if (expressionGroupsCount === 1) {
        e.target.closest(".expression-controls").remove();
      }
    }

    // Remove expression
    if (e.target.classList.contains("js-remove-expression")) {
      // Remove the expression and its remove button tooltip
      var expression = e.target.closest(".expression");
      var tooltip = bootstrap.Tooltip.getInstance(e.target);

      var form = expression.closest("form");
      var expressionGroup = expression.closest(".expression-group");

      if (tooltip) {
        tooltip.dispose();
      }

      expression.remove();

      // If there are no more expressions in the form, add back in the root
      // expression controls, otherwise remove any expression groups without direct
      // children, even if their descendant expression groups are not empty.
      var expression = form.querySelector(".expression");

      if (!expression) {
        if (expressionGroup) {
          expressionGroup.remove();
        }

        var template = document.querySelector("#expression-controls");
        var expressionControls = template.content.cloneNode(true);
        var expressions = form.querySelector(".expressions");

        expressions.appendChild(expressionControls);
      } else if (expressionGroup) {
        var expressionGroupExpression = expressionGroup.querySelector(".expression");

        if (!expressionGroupExpression) {
          expressionGroup.remove();
        } else if (expressionGroupExpression.closest('.expression-group') !== expressionGroup) {
          expressionGroup.remove();
        }
      }
    }
  });
});
