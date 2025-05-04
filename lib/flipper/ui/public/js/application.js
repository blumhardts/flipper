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

  initializeExpression();
});

function initializeExpression() {
  var rootExpression = document.querySelector(".expression");

  if (!rootExpression) {
    return;
  }

  addExpressionControls(rootExpression);

  document.addEventListener("click", function (e) {
    if (e.target.classList.contains("js-add-group-expression")) {
      var form = e.target.closest("form");
      var container = e.target.closest(".add-expression-controls").previousElementSibling;
      var groupType = e.target.dataset.groupType;

      addGroupExpression(form, container, groupType);
    }

    if (e.target.classList.contains("js-add-property-expression")) {
      var form = e.target.closest("form");
      var container = e.target.closest(".add-expression-controls").previousElementSibling;

      addPropertyExpression(form, container);
    }

    if (e.target.classList.contains("js-remove-property-expression")) {
      var form = e.target.closest("form");
      var expression = e.target.closest(".property-expression");
      var tooltip = bootstrap.Tooltip.getInstance(e.target);

      if (tooltip) {
        tooltip.dispose();
      }

      removePropertyExpression(form, expression, tooltip);
    }
  });

  document.addEventListener("change", function (e) {
    if (e.target.classList.contains("js-change-property-expression-property")) {
      var expression = e.target.closest(".property-expression");
      var type = e.target.querySelector("option:checked").dataset.type;

      if (expression.dataset.type !== type) {
              setPropertyExpressionControls(expression, type);
      }
    }
  });
}

function addGroupExpression(form, container, type) {
  var template = document.getElementById("group-expression");
  var fragment = template.content.cloneNode(true);

  fragment.querySelector(".badge").textContent = type;

  container.appendChild(fragment);

  var groupExpressions = container.querySelectorAll(".group-expression");
  var groupExpression = groupExpressions[groupExpressions.length - 1];
  var expressions = groupExpression.querySelector(".expressions");

  addPropertyExpression(form, expressions);
  addExpressionControls(expressions);
}

function addPropertyExpression(form, container) {
  var existing = container.querySelector(".property-expression");
  var template = document.getElementById("property-expression");
  var fragment = template.content.cloneNode(true);

  if (!existing) {
    form.querySelector(".add-expression-controls").remove();
  }

  if (isGroupExpression(container)) {
    fragment.querySelector(".property-expression").classList.add(template.dataset.marginClass);
  }

  setPropertyExpressionControls(fragment, "string");

  container.appendChild(fragment);

  var removeButtons = container.querySelectorAll(".js-remove-property-expression");
  var removeButton = removeButtons[removeButtons.length - 1];
  new bootstrap.Tooltip(removeButton);
}

function removePropertyExpression(form, expression) {
  var groupExpression = expression.closest(".group-expression");

  expression.remove();

  if (groupExpression) {
    var other = groupExpression.querySelector(".property-expression")

    if (!other || other.closest(".group-expression") !== groupExpression) {
      groupExpression.remove();
    }
  }

  if (!form.querySelector(".property-expression")) {
    addExpressionControls(form.querySelector(".expression"));
  }
}

function addExpressionControls(container) {
  var template = document.getElementById("add-expression-controls");
  var fragment = template.content.cloneNode(true);

  if (isGroupExpression(container) && !isRootGroupExpression(container)) {
    fragment.querySelector(".add-expression-controls").classList.add(template.dataset.marginClass);
  };

  container.after(fragment);
}

function isRootGroupExpression(container) {
  var existing = container.closest("form").querySelectorAll(".expressions");

  if (existing.length === 1 && existing[0] == container) {
    return true;
  }
}

function isGroupExpression(container) {
  return container.classList.contains("expressions");
}

var propertyExpressionControlIds = {
  string: {
    operator: "property-expression-default-operator-control",
    value: "property-expression-string-value-control",
  },
  number: {
    operator: "property-expression-default-operator-control",
    value: "property-expression-number-value-control",
  },
  boolean: {
    operator: "property-expression-boolean-operator-control",
    value: "property-expression-boolean-value-control",
  }
};

function setPropertyExpressionControls(expression, type) {
  var operatorTemplate = document.getElementById(propertyExpressionControlIds[type].operator);
  var operatorFragment = operatorTemplate.content.cloneNode(true);

  expression.querySelector(".expression-operator-control").replaceChildren(operatorFragment);

  var valueTemplate = document.getElementById(propertyExpressionControlIds[type].value);
  var valueFragment = valueTemplate.content.cloneNode(true);

  expression.querySelector(".expression-value-control").replaceChildren(valueFragment);

  if (expression instanceof DocumentFragment) {
    expression = expression.firstElementChild.dataset.type = type;
  } else {
    expression.dataset.type = type;
  }
}
