
String getInitials({String title}) {
  if(title.length > 1) {
    String noteTitle = title[0] + title[1];
    return noteTitle;
  } else {
    return title[0];
  }

}
