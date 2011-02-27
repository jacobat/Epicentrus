// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.fn.autolink = function () {
    return this.each( function(){
        var re = 
/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g;
        $(this).html( $(this).html().replace(re, '<a href="$1">$1</a> ') );
    });
}