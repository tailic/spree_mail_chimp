jQuery.ajaxSetup({
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

var subscribe_email_default_txt = '';
var fname_default_txt = '';
var lname_default_txt = '';
var zip_code_default_txt = '';

var SpreeMailchimpApp = {
  doSubmit: function(e) {
          SpreeMailchimpApp.getBusy(null); // could really use $.proxy here but spree doesn't have 1.4
          $.post(this.action+'.js', $(this).serialize(), SpreeMailchimpApp.getNotBusy, "script");
          return false;
  },
  getBusy : function( fn ) {
          $("#busy_indicator").fadeIn('fast', fn);
  },
  getNotBusy : function() {
          $("#busy_indicator").fadeOut('fast');
  }
};

jQuery(document).ready( function() {

    subscribe_email_default_txt = $('#email').val();
    fname_default_txt = $('#fname').val(); 
    lname_default_txt = $('#lname').val(); 
    zip_code_default_txt = $('#mmerge3').val(); 


    $('#email').bind('focus', function() {
      if (this.value == subscribe_email_default_txt) this.value = '';
    });
    $('#email').bind('blur', function() {
      if (this.value == '') this.value = subscribe_email_default_txt;
    });
    $('#fname').bind('focus', function() {
      if (this.value == fname_default_txt) this.value = '';
    });
    $('#fname').bind('blur', function() {
      if (this.value == '') this.value = fname_default_txt;
    });
    $('#lname').bind('focus', function() {
      if (this.value == lname_default_txt) this.value = '';
    });
    $('#lname').bind('blur', function() {
      if (this.value == '') this.value = lname_default_txt;
    });
    $('#mmerge3').bind('focus', function() {
      if (this.value == zip_code_default_txt) this.value = '';
    });
    $('#mmerge3').bind('blur', function() {
      if (this.value == '') this.value = zip_code_default_txt;
    });
    $('#mailchimp_subscribe_wrap form').bind('submit', SpreeMailchimpApp.doSubmit);
});
