$(document).ready(function(){
  // extract date from the url
  url = decodeURIComponent(window.location.href)
  date = (url.split("/")[url.split("/").length - 1]).split("-")

  if($("#worker-id-for-calendar")[0] != undefined){
    $.get("/dashboard/workers/"+$("#worker-id-for-calendar").text().trim()+"/calendar/tasks/calendar_events").done(function(response){
      fullCalendar(response);
    });
  }else{
    fullCalendar([]);
  }
  // set sent date by url on calendar
  $("#worker-calendar").fullCalendar("gotoDate", new Date(date[0], parseInt(date[1])-1, date[2]));
});

function dateFormat(date){
  return date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
}

function fullCalendar(tasks){
  $('#worker-calendar').fullCalendar({
    header: {
      left: 'prev,today,next',
      center: 'title',
      right: 'agendaDay,agendaWeek,month'
    },
    defaultView: 'agendaDay',
    editable: false,
    allDaySlot: false,
    selectable: true,
    // dayClick: function(date, jsEvent, view) {
    //   window.location = "/dashboard/workers/"+$("#worker-id-for-calendar").text().trim()+"/calendar/tasks/new?date="+dateFormat(date)
    // },
    // events: tasks,
    eventColor: '#E0E0F8',
    eventTextColor: '#08088A'
  });
}