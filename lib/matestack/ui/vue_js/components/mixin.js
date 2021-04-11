import matestackEventHub from '../event_hub'

const componentMixin = {
  props: ['props', 'params'],
  methods: {
    registerEvents: function(events, callback){
      if(events != undefined){
        var event_names = events.split(",")
        event_names.forEach(event_name => matestackEventHub.$on(event_name.trim(), callback));
      }
    },
    removeEvents: function(events, callback){
      if(events != undefined){
        var event_names = events.split(",")
        event_names.forEach(event_name => matestackEventHub.$off(event_name.trim(), callback));
      }
    }
  }

}

export default componentMixin
