

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

// shameless stolen from a W3schools page.
// modified for optional numeric sorting and to always sort blanks below included values
function sortTable(n, numeric=false) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  table = document.getElementById("tournament_participants");
  switching = true;
  // Set the sorting direction to ascending:
  dir = "asc";
  /* Make a loop that will continue until
  no switching has been done: */
  while (switching) {
    // Start by saying: no switching is done:
    switching = false;
    rows = table.rows;
    /* Loop through all table rows (except the
    first, which contains table headers): */
    for (i = 1; i < (rows.length - 1); i++) {
      // Start by saying there should be no switching:
      shouldSwitch = false;
      /* Get the two elements you want to compare,
      one from current row and one from the next: */
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      /* Check if the two rows should switch place,
      based on the direction, asc or desc: */
      if (dir == "asc") {
        if (numeric){
          x1 = Number(x.innerHTML)
          y1 = Number(y.innerHTML)
          if (x1 == 0 ) { x1 = 10000 }
          if (y1 == 0 ) { y1 = 10000 }
          if (x1 > y1) {
            shouldSwitch = true;
            break;
          }
        }
        else {
          if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
            // If so, mark as a switch and break the loop:
            shouldSwitch = true;
            break;
          }
        }
      } else if (dir == "desc") {
        if (numeric){
          x1 = Number(x.innerHTML)
          y1 = Number(y.innerHTML)
          if (x1 == 0 ) { x1 = -1000 }
          if (y1 == 0 ) { y1 = -1000 }
          if (x1 < y1) {
            shouldSwitch = true;
            break;
          }
        }
        else {
          if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
            // If so, mark as a switch and break the loop:
            shouldSwitch = true;
            break;
          }
        }
      }
    }
    if (shouldSwitch) {
      /* If a switch has been marked, make the switch
      and mark that a switch has been done: */
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      // Each time a switch is done, increase this count by 1:
      switchcount ++;
    } else {
      /* If no switching has been done AND the direction is "asc",
      set the direction to "desc" and run the while loop again. */
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}