

function toggle_filter_visibility() {
  var filter_card = document.getElementById("tournament_filter_bar_card")
  if ( filter_card.classList.contains('d-none') ){
    filter_card.classList.remove('d-none')
  } else {
    filter_card.classList.add('d-none');
  }
}