function PhotoUploader(formTemplate) {
    var selector = ('input[data-file="true"]');

    this.addUploadListener = function () {
        var fileInputSelector = $(selector);
        fileInputSelector.each(function () {
            var $fileInput = $(this);
            var form = $(formTemplate.replace('###URL###', $fileInput.data("path"))
                .replace('###CONTAINER###', $fileInput.data('container'))
                .replace('###FREE_SIZE###', $fileInput.data('free_size'))
                .replace('###VERSION###', $fileInput.data('version')));
            $('body').append(form);

            (function addChangeListener(fileInput) {
                fileInput.change(function () {
                    var $c = $('#' + fileInput.data('container'));
                    $c.find("[data-image-loader]").addClass('visible');
                    $c.find('[data-image-preview]').hide();
                    $c.find('[data-image-placeholder]').hide();
                    $c.find('[data-image-remove-flag]').val(0);

                    // DO NOT REFACTOR!!! A bit of black magic
                    var clonedCopy = $(this).clone().appendTo($(this).parent());
                    clonedCopy.val('');
                    addChangeListener(clonedCopy);
                    form.find('input[type="file"]').remove();
                    $(this).detach().appendTo(form);
                    form.submit();
                });
            })($(this));
        });

        $('.upload-img-container').find('[data-image-tag]').load(function () {
            var
                $this = $(this),
                $cnt = $this.closest('.img-polaroid'),
                updateSizes = $this.closest('.upload-img-container').hasClass('manage-size'),
                w = $this[0].width,
                h = $this[0].height;

            if (updateSizes) {
                $this.css({width: w + "px", height: h + "px"});
                $cnt.css({width: w + "px", height: h + "px"});
                $cnt.find("[data-image-placeholder]").css({width: w + "px", height: h + "px", 'line-height': h + 'px'});
            }

            if (!$cnt.hasClass('init-placeholder')) {
                $cnt.find('[data-image-loader]').removeClass('visible');
                $cnt.find('[data-image-preview]').show();
            } else {
                if (updateSizes) {
                    $this.removeAttr('width').removeAttr('height');
                }
            }
        });

    };
}