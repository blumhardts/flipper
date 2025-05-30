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
    var typeRadios = expressionForm.querySelectorAll('input[name="expression_type"]');
    var simpleForm = document.getElementById("simple-expression-form");
    var complexForm = document.getElementById("complex-expression-form");
    var addExpressionBtn = document.getElementById("add-expression-btn");
    var expressionList = document.getElementById("expression-list");
    var expressionCounter = 0;

    // Handle expression type changes
    typeRadios.forEach(function(radio) {
      radio.addEventListener("change", function() {
        if (this.value === "property") {
          simpleForm.classList.remove("d-none");
          complexForm.classList.add("d-none");
        } else {
          simpleForm.classList.add("d-none");
          complexForm.classList.remove("d-none");
          // Add initial expression if none exist
          if (expressionList.children.length === 0) {
            addExpressionRow();
          }
        }
      });
    });

    // Add expression row for complex forms
    function addExpressionRow() {
      var row = document.createElement("div");
      row.className = "row mb-2";
      row.innerHTML = `
        <div class="col-md-4">
          <select name="complex_expressions[${expressionCounter}][property]" class="form-select" required>
            <option value="">Select a property...</option>
            ${getPropertiesOptions()}
          </select>
        </div>
        <div class="col-md-3">
          <select name="complex_expressions[${expressionCounter}][operator]" class="form-select" required>
            <option value="">Select an operator...</option>
            <option value="eq">equals (=)</option>
            <option value="ne">not equal (≠)</option>
            <option value="gt">greater than (>)</option>
            <option value="gte">greater than or equal (≥)</option>
            <option value="lt">less than (<)</option>
            <option value="lte">less than or equal (≤)</option>
          </select>
        </div>
        <div class="col-md-3">
          <input type="text" name="complex_expressions[${expressionCounter}][value]" placeholder="value" class="form-control" required>
        </div>
        <div class="col-auto">
          <button type="button" class="btn btn-outline-danger btn-sm remove-expression-btn">Remove</button>
        </div>
      `;
      expressionList.appendChild(row);
      expressionCounter++;

      // Add event listener to remove button
      row.querySelector(".remove-expression-btn").addEventListener("click", function() {
        row.remove();
      });
    }

    // Get properties options from existing select
    function getPropertiesOptions() {
      var simpleSelect = simpleForm.querySelector('select[name="expression_property"]');
      var options = "";
      for (var i = 0; i < simpleSelect.options.length; i++) {
        var option = simpleSelect.options[i];
        options += `<option value="${option.value}">${option.textContent}</option>`;
      }
      return options;
    }

    // Add expression button click handler
    if (addExpressionBtn) {
      addExpressionBtn.addEventListener("click", addExpressionRow);
    }

    // Form submission handling for complex expressions
    expressionForm.addEventListener("submit", function(e) {
      var selectedType = expressionForm.querySelector('input[name="expression_type"]:checked');
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
