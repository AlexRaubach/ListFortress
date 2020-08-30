

function toggle_filter_visibility() {
  var filter_card = document.getElementById("tournament_filter_bar_card")
  if ( filter_card.classList.contains('d-none') ){
    filter_card.classList.remove('d-none');
    document.cookie = "filter_bar=1; path=/"
  } else {
    filter_card.classList.add('d-none');
    document.cookie = "filter_bar=; expires=Thu, 01-Jan-70 00:00:01 UTC; path=/"
  }
}

function update_filter_with_query_string_params(){
  const urlParams = new URLSearchParams(location.search);

  for (const [key, value] of urlParams) {
    if (value != "" && document.getElementById(key)){
      document.getElementById(key).value = value;
    }
  }
}
