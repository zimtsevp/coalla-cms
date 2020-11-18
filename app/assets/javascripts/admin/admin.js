// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require admin/jquery-migrate.min
//= require jquery-ui
//= require jquery-ui/datepicker-ru
//= require jquery-ui-timepicker-addon
//= require admin/vendor/jquery-ui-timepicker-addon-ru
//= require jquery_ujs
//= require admin/vendor/bootstrap.min
//= require jquery.remotipart
//= require admin/vendor/jquery.tokeninput.patched
//= require admin/vendor/jquery.tagsinput
//= require admin/vendor/underscore-min
//= require js-routes
//= require ckeditor/init
//= require admin/photo_uploader
//= require_self
//= require admin/custom_admin

var CMS = CMS || {};
CMS.config = CMS.config || {};
CMS.config.language = CMS.config.language || 'ru';

function injectNewSliderId(s, id) {
    return s.replace(/NEW_RECORD/g, id);
}

(function ($) {
    $.fn.stickyBar = function () {
        if (this.length) {
            var $bar = this,
                barOffsetTop = $bar.offset().top,
                barOuterHeight = $bar.outerHeight(),
                windowScrollTop = $(window).scrollTop(),
                windowHeight = $(window).height();

            if (barOffsetTop + barOuterHeight > windowScrollTop + windowHeight) {
                $bar.addClass('__sticky');
            }

            $(window).scroll(function () {
                windowScrollTop = $(window).scrollTop();
                windowHeight = $(window).height();

                if (barOffsetTop + barOuterHeight > windowScrollTop + windowHeight) {
                    $bar.addClass('__sticky');
                } else {
                    $bar.removeClass('__sticky');
                }
            });
        }
    }

})(jQuery);

$(function () {
    $(document).on('click', '.pictograms__button_remove', function () {
        var
            $this = $(this),
            container = '.' + $this.data('container');
        var input = $this.prev(':hidden');
        if (input.size() > 0) {
            $(input[0]).attr("value", "1");
            $this.closest(container).hide();
        } else {
            $(this).closest(container).remove();
        }
        return false;
    });

    $(document).on('click', '[data-image-remove-btn]', function () {
        var container = $(this).closest('.upload-img-container');
        container.find('[data-image-preview]').hide();
        container.find('[data-image-placeholder]').show();
        container.find('[data-image-remove-flag]').val(1);
        return false;
    });

    $('.sortable').sortable();

    function merge_datepicker_options($element) {
        var options = {
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true
        };
        var customOptions = $element.data('calendar-options');
        if (customOptions) {
            options = $.extend(options, customOptions);
        }
        return options;
    }

    function addDatePickers() {
        $('input[data-calendar-date]').each(function () {
            $this = $(this);
            $this.datepicker(merge_datepicker_options($this));
        });
    }

    addDatePickers();

    function addDateTimePickers() {
        $('input[data-calendar-datetime]').each(function () {
            $this = $(this);
            $this.datetimepicker(merge_datepicker_options($this));
        });
    }

    addDateTimePickers();

    function addTimePickers() {
        $('input[data-calendar-time]').each(function () {
            $this = $(this);
            $this.timepicker(merge_datepicker_options($this));
        });
    }

    addTimePickers();

    $(document).on('click', '.close-popover-form', function () {
        $('.pictograms__button_edit').popover('hide');
        $('.popover').css('display', 'none');
    });

    $(document).on('click', '.submit-popover-form', function () {
        var
            $title = $(this).closest('.slide-form-group').find('input[type="text"]');
        $('#' + $title.attr('id')).val($title.val());
        $('.pictograms__button_edit').popover('hide');
        $('.popover').css('display', 'none');
    });

    var $form = $('form');
    $form.on('click', '.remove_field', function () {
        $(this).prev('input[type=hidden]').val('1');
        $(this).closest('.fields_container').hide();
        return false;
    });

    $form.on('click', '.add_fields', function () {
        var time = new Date().getTime();
        var regexp = new RegExp($(this).data('id'), 'g');
        $(this).before($(this).data('fields').replace(regexp, time));
        window.NestedFormCallbacks = window.NestedFormCallbacks || [];
        _.each(window.NestedFormCallbacks, function (callback) {
            callback();
        });
        addDatePickers();
        addDateTimePickers();
        addTimePickers();
        return false
    });

    $('[data-multi-field]').each(function () {
        var options = {
            crossDomain: false,
            preventDuplicates: true,
            theme: 'facebook',
            showAllOnFocus: $(this).data('show-all-on-focus'),
            useCache: $(this).data('use-cache')
        };

        if (CMS.config.language == 'ru') {
            options.hintText = 'Введите строку для поиска';
            options.noResultsText = 'Ничего не найдено';
            options.searchingText = 'Поиск...';
        }

        var objectUrlName = $(this).data('object-url-name');
        if (objectUrlName) {
            var formatter_options = {
                tokenFormatter: function (item) {
                    return "<li><p><a href='" + "/admin/" + objectUrlName + "/" + item['id'] + "/edit'>" + item[this.propertyToSearch] + "</a></p></li>"
                }
            };
            options = $.extend(options, formatter_options);
        }

        $(this).tokenInput($(this).data('source'), options);
    });

    $('.action-bar').stickyBar();

    $(document).on('change', '[data-file-upload]', function () {
        var filename = $(this).val().replace(/.*(\/|\\)/, ''),
            container = $(this).closest('[data-file-upload-container]');

        container.find('[data-file-upload-title]').text(filename);

        if (filename.length > 0) {
            container.find('[data-file-remove-flag]').val(0);
        }
    });

    $(document).on('click', '[data-file-remove-btn]', function () {
        var container = $(this).closest('[data-file-upload-container]'),
            title = container.find('[data-file-upload-title]');
        title.text(title.data('label'));
        container.find('[data-file-upload]').val('');
        container.find('[data-file-remove-flag]').val(1);
        return false;
    });

    $('[data-toggle="tooltip"]').tooltip({'trigger':'focus'});

});

CKEDITOR.config.extraPlugins = 'slideshow,mediaembed,autogrow';
CKEDITOR.config.removeButtons = 'About,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,BidiLtr,BidiRtl,Language,Scayt,Smiley,SpellChecker,Templates,Indent,CreateDiv,HorizontalRule,Flash,NewPage,PageBreak,Iframe,Styles,FontSize,Font,TextColor,BGColor,JustifyLeft,JustifyCenter,JustifyRight,JustifyBlock';
CKEDITOR.config.removePlugins = 'scayt,smiley';
CKEDITOR.config.language = 'ru';