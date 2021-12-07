const functions = require('firebase-functions');
const admin = require('firebase-admin');
const _ = require('lodash');
const notificationService = require('./NotificationService')
const userService = require('./UserService')

const FireStore = {
    Collection: {
        Content: 'content',
        Game: 'game',
        Users: 'users'
    },
    Field: {
        Name: 'name'
    }
}

class GameService {

    /**
     * Create a tournament
     * @param {*} param
     */
    async createTournament({
        name
    }) {

        const params = _.omitBy({
            name
        }, _.isNull);

        const res = await admin.firestore().collection(FireStore.Collection.Game).add(params);
        const id = res.id
        const doc = await admin.firestore().collection(FireStore.Collection.Game).doc(id).get();
        const tournament = { id, ...doc.data() };

        // send notification to particpants and judge
        await this.sendTournamentCreateNotification(tournament)

        return tournament;
    }
}



// Module export exposes classes, variables, functions to other javascript files
module.exports = new TournamentService();