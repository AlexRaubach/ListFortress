// Shows which log file was selected on the league match form. Delegated from the
// document so it keeps working across Turbolinks visits.
$(document).on('change', '.custom-file-input', function() {
  $('.custom-file-label').text(this.value);
});
