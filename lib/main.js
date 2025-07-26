
exports.consumeHyperlinkInjection = (hyperlink) => {
  hyperlink.addInjectionPoint('source.fortran', {
    types: ['comment', 'string_literal']
  });
};

exports.consumeTodoInjection = (todo) => {
  todo.addInjectionPoint('source.fortran', {
    types: ['comment']
  });
};
