qBinding = {}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            qBinding.Close();
            break;
    }
});

$(document).ready(function(){
    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "openBinding") {
            
            qBinding.Open(eventData);
        }
    });
});

$(document).on('click', '.save-bindings', function(e){
    e.preventDefault();

    var keyData = {}
    keyData['f2'] = [$("#command-f2").val(), $("#argument-f2").val()]
    keyData['f4'] = [$("#command-f4").val(), $("#argument-f4").val()]
    keyData['f5'] = [$("#command-f5").val(), $("#argument-f5").val()]
    keyData['f7'] = [$("#command-f7").val(), $("#argument-f7").val()]
    keyData['f9'] = [$("#command-f9").val(), $("#argument-f9").val()]
    keyData['f10'] = [$("#command-f10").val(), $("#argument-f10").val()]

    $.post('https://qb-commandbinding/save', JSON.stringify({
        keyData: keyData
    }));

    $(".container").fadeOut(150);
    $.post('https://qb-commandbinding/close');
});

qBinding.Open = function(data) {
    $(".container").fadeIn(150);

    $.each(data.keyData, function(id, keyData){
        var commandString = $(".keys").find("[data-key='" + id + "']").find('#command-'+id) //(".keys").find
        var argumentString = $(".keys").find("[data-key='" + id + "']").find('#argument-'+id)

        if (keyData.command != null) {
            $(commandString).val(keyData.command)
        }
        if (keyData.argument != null) {
            $(argumentString).val(keyData.argument)
        }
    });
}

qBinding.Close = function() {
    $(".container").fadeOut(150);
    $.post('https://qb-commandbinding/close');
}