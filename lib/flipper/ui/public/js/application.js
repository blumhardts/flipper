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

  // Expression form handling
  var expressionForm = document.getElementById("expression-form");
  if (expressionForm) {
    var typeRadios = document.querySelectorAll('input[name="expression_type"]');
    var simpleForm = document.getElementById("simple-expression-form");
    var complexForm = document.getElementById("complex-expression-form");
    var addExpressionBtn = document.getElementById("add-expression-btn");
    var expressionList = document.getElementById("expression-list");
    var expressionCounter = 0;

    // Update remove button states based on number of expressions
    function updateRemoveButtonStates() {
      var expressionRows = expressionList.querySelectorAll(".row");
      var removeButtons = expressionList.querySelectorAll(".remove-expression-btn");

      removeButtons.forEach(function(btn) {
        if (expressionRows.length <= 1) {
          btn.disabled = true;
          btn.title = "Cannot remove the last expression";
        } else {
          btn.disabled = false;
          btn.title = "";
        }
      });
    }

    // Initialize form state based on checked radio button
    var checkedRadio = document.querySelector('input[name="expression_type"]:checked');
    if (checkedRadio) {
      if (checkedRadio.value === "property") {
        simpleForm.classList.remove("d-none");
        complexForm.classList.add("d-none");
        if (addExpressionBtn) {
          addExpressionBtn.disabled = true;
          addExpressionBtn.title = "Add Expression is only available for Any/All expression types";
        }
      } else {
        simpleForm.classList.add("d-none");
        complexForm.classList.remove("d-none");
        if (addExpressionBtn) {
          addExpressionBtn.disabled = false;
          addExpressionBtn.title = "";
        }
        // Update button states if there are existing expressions
        updateRemoveButtonStates();
      }
    }

    // Handle expression type changes
    typeRadios.forEach(function(radio) {
      radio.addEventListener("change", function() {
        if (this.value === "property") {
          simpleForm.classList.remove("d-none");
          complexForm.classList.add("d-none");
          if (addExpressionBtn) {
            addExpressionBtn.disabled = true;
            addExpressionBtn.title = "Add Expression is only available for Any/All expression types";
          }
        } else {
          simpleForm.classList.add("d-none");
          complexForm.classList.remove("d-none");
          if (addExpressionBtn) {
            addExpressionBtn.disabled = false;
            addExpressionBtn.title = "";
          }
          // Add initial expression if none exist
          if (expressionList.children.length === 0) {
            addExpressionRow();
          }
        }
      });
    });

    // Add expression row for complex forms
    function addExpressionRow() {
      var template = document.getElementById("expression-row-template");
      var row = template.content.cloneNode(true);

      // Update the counter in name attributes
      var selects = row.querySelectorAll("select");
      var inputs = row.querySelectorAll("input");

      selects.forEach(function(select) {
        select.name = select.name.replace("COUNTER", expressionCounter);
      });

      inputs.forEach(function(input) {
        input.name = input.name.replace("COUNTER", expressionCounter);
      });

      // Add event listener to remove button
      var removeBtn = row.querySelector(".remove-expression-btn");
      removeBtn.addEventListener("click", function() {
        removeBtn.closest(".row").remove();
        updateRemoveButtonStates();
      });

      expressionList.appendChild(row);
      expressionCounter++;
      updateRemoveButtonStates();
    }

    // Add expression button click handler
    if (addExpressionBtn) {
      addExpressionBtn.addEventListener("click", addExpressionRow);
    }

    // Form submission handling for complex expressions
    expressionForm.addEventListener("submit", function(e) {
      var selectedType = document.querySelector('input[name="expression_type"]:checked');
      if (selectedType && (selectedType.value === "any" || selectedType.value === "all")) {
        // Validate at least one expression exists
        var expressions = expressionList.querySelectorAll(".row");
        if (expressions.length === 0) {
          e.preventDefault();
          alert("Please add at least one expression.");
          return;
        }

        // Add hidden input for expression type
        var typeInput = document.createElement("input");
        typeInput.type = "hidden";
        typeInput.name = "complex_expression_type";
        typeInput.value = selectedType.value;
        expressionForm.appendChild(typeInput);
      }
    });
  }
});
