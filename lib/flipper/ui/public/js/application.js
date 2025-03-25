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

  document.querySelectorAll(".js-add-expression-group").forEach(function (button) {
    button.addEventListener("click", function () {
      var template = document.querySelector("#expression-group");
      var clone = template.content.cloneNode(true);

      var title = clone.querySelector("h6 > strong");
      var groupType = button.datasetGroupType;
      title.textContent = groupType

      var form = button.closest("form");
      var expressionsContainer = form.querySelector(".expressions");
      expressionsContainer.appendChild(clone);

      // Setup buttons
      // var buttons = clone.querySelectorAll("button");
      // buttons[0].classList.add("js-add-group-expression");
      // buttons[1].classList.add("js-add-group");

      // // Add remove button if nested
      // if (isNested) {
      //   var removeBtn = document.createElement("button");
      //   removeBtn.type = "button";
      //   removeBtn.className =
      //     "btn btn-sm btn-outline-danger ms-2 js-remove-group";
      //   removeBtn.innerHTML = "Remove";
      //   buttons[1].parentNode.appendChild(removeBtn);
      // }

      // // Create container for child expressions
      // var expressionsContainer = document.createElement("div");
      // expressionsContainer.className = "group-expressions";
      // clone.querySelector(".row").after(expressionsContainer);

      // // Add the group to the container
      // container.appendChild(clone);

      // return container.lastElementChild;
    });
  });

   // Here be AI

    //  document.querySelectorAll(".js-add-expression").forEach(function (button) {
    //    button.addEventListener("click", function () {
    //      var form = button.closest("form");

    //      // Check if we're adding to root or to a group
    //      var target;
    //      if (button.dataset.root) {
    //        // Check if there's already a group
    //        target =
    //          form.querySelector(".group-expressions") ||
    //          form.querySelector(".expressions");

    //        // If we're trying to add directly to the root and there's no group, and there's already an expression
    //        if (
    //          !form.querySelector(".group-expressions") &&
    //          form.querySelector(".expression")
    //        ) {
    //          return;
    //        }
    //      } else {
    //        // Adding to a group
    //        target = button
    //          .closest(".expression-group")
    //          .querySelector(".group-expressions");
    //      }

    //      addExpressionToGroup(target);

    //      // Disable root add button if there's no group (only allow one expression outside groups)
    //      if (button.dataset.root && !form.querySelector(".group-expressions")) {
    //        button.disabled = true;
    //      }
    //    });
    //  });

    //  // Use event delegation for dynamically added elements
    //  document.addEventListener("click", function (e) {
    //    // Handle removing expressions
    //    if (e.target.classList.contains("js-remove-expression")) {
    //      var expression = e.target.closest(".expression");
    //      var tooltip = bootstrap.Tooltip.getInstance(e.target);

    //      if (tooltip) {
    //        tooltip.dispose();
    //      }

    //      expression.remove();

    //      // Re-enable the root add button if there are no more expressions outside groups
    //      var form = expression.closest("form");
    //      var rootAddButton = form.querySelector(
    //        ".js-add-expression[data-root]"
    //      );

    //      if (
    //        rootAddButton &&
    //        !form.querySelector(".group-expressions") &&
    //        form.querySelectorAll(".expression").length === 0
    //      ) {
    //        rootAddButton.disabled = false;
    //      }
    //    }

    //    // Handle adding expressions to groups
    //    if (e.target.classList.contains("js-add-group-expression")) {
    //      var groupContainer = e.target.closest(".expression-group");
    //      var expressionsContainer =
    //        groupContainer.querySelector(".group-expressions");
    //      addExpressionToGroup(expressionsContainer);
    //    }

    //    // Handle adding nested groups
    //    if (e.target.classList.contains("js-add-group")) {
    //      var parentGroupContainer = e.target.closest(".expression-group");
    //      var parentExpressionsContainer =
    //        parentGroupContainer.querySelector(".group-expressions");

    //      // Toggle between Any and All for nested groups
    //      var parentGroupType = parentGroupContainer.querySelector(
    //        "input[name*='group']"
    //      ).value;
    //      var nestedGroupType = parentGroupType === "any" ? "all" : "any";

    //      createExpressionGroup(
    //        parentExpressionsContainer,
    //        nestedGroupType,
    //        true
    //      );
    //    }

    //    // Handle removing groups
    //    if (e.target.classList.contains("js-remove-group")) {
    //      var group = e.target.closest(".expression-group");
    //      group.remove();

    //      // Re-enable the root add button if needed
    //      var form = e.target.closest("form");
    //      var rootAddButton = form.querySelector(
    //        ".js-add-expression[data-root]"
    //      );

    //      if (rootAddButton && !form.querySelector(".expression")) {
    //        rootAddButton.disabled = false;
    //      }
    //    }
    //  });

    //  // Function to create an expression group
    //  function createExpressionGroup(container, groupType, isNested = false) {
    //    var template = document.querySelector("#expression-group");
    //    var clone = template.content.cloneNode(true);

    //    // Set the group type (any/all)
    //    var groupInput = clone.querySelector("input[name*='group']");
    //    groupInput.value = groupType;

    //    // Update the name to include proper nesting if needed
    //    if (isNested) {
    //      var parentNamePrefix = container
    //        .closest(".expression-group")
    //        .querySelector("input").name;
    //      var nestedName = parentNamePrefix.replace(/\[\]$/, "[expressions][]");
    //      groupInput.name = nestedName;
    //    }

    //    // Set the display text
    //    var groupDisplay = clone.querySelector(".fw-bold");
    //    groupDisplay.textContent =
    //      groupType.charAt(0).toUpperCase() + groupType.slice(1);

    //    // Setup buttons
    //    var buttons = clone.querySelectorAll("button");
    //    buttons[0].classList.add("js-add-group-expression");
    //    buttons[1].classList.add("js-add-group");

    //    // Add remove button if nested
    //    if (isNested) {
    //      var removeBtn = document.createElement("button");
    //      removeBtn.type = "button";
    //      removeBtn.className =
    //        "btn btn-sm btn-outline-danger ms-2 js-remove-group";
    //      removeBtn.innerHTML = "Remove";
    //      buttons[1].parentNode.appendChild(removeBtn);
    //    }

    //    // Create container for child expressions
    //    var expressionsContainer = document.createElement("div");
    //    expressionsContainer.className = "group-expressions";
    //    clone.querySelector(".row").after(expressionsContainer);

    //    // Add the group to the container
    //    container.appendChild(clone);

    //    return container.lastElementChild;
    //  }

    //  // Function to add an expression to a group
    //  function addExpressionToGroup(
    //    container,
    //    values = { property: "", operator: "", value: "" }
    //  ) {
    //    var template = document.querySelector("#expression");
    //    var clone = template.content.cloneNode(true);

    //    // If this is within a group, adjust the name
    //    if (container.classList.contains("group-expressions")) {
    //      var parentGroup = container.closest(".expression-group");
    //      var parentNamePrefix = parentGroup.querySelector("input").name;
    //      var expressionFields = clone.querySelectorAll("[name]");

    //      expressionFields.forEach(function (field) {
    //        field.name =
    //          parentNamePrefix.replace(/\[\]$/, "[expressions][]") +
    //          field.name.substring(field.name.indexOf("["));
    //      });
    //    }

    //    // Set values if provided
    //    if (values.property) {
    //      var propertySelect = clone.querySelector("select[name*='property']");
    //      for (var i = 0; i < propertySelect.options.length; i++) {
    //        if (propertySelect.options[i].value === values.property) {
    //          propertySelect.selectedIndex = i;
    //          break;
    //        }
    //      }
    //    }

    //    if (values.operator) {
    //      var operatorSelect = clone.querySelector("select[name*='operator']");
    //      for (var i = 0; i < operatorSelect.options.length; i++) {
    //        if (operatorSelect.options[i].value === values.operator) {
    //          operatorSelect.selectedIndex = i;
    //          break;
    //        }
    //      }
    //    }

    //    if (values.value) {
    //      clone.querySelector("input[name*='value']").value = values.value;
    //    }

    //    // Add tooltip to remove button
    //    var removeButton = clone.querySelector(".js-remove-expression");
    //    removeButton.setAttribute("data-bs-toggle", "tooltip");
    //    removeButton.setAttribute("data-bs-placement", "left");
    //    removeButton.setAttribute("title", "Remove expression");

    //    container.appendChild(clone);

    //    // Initialize tooltip
    //    new bootstrap.Tooltip(
    //      container.lastElementChild.querySelector(".js-remove-expression")
    //    );

    //    return container.lastElementChild;
    //  }
});
