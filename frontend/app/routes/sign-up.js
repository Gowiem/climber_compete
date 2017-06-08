import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.createRecord('user');
  },

  actions: {
    submit(model) {
      console.log("Sign Up Submit!");
      model.save().then(() => {
        console.log("Success creating user!");
      });
    }
  }
});
