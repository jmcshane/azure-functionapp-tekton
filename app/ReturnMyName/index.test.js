const httpFunction = require('./index');
const context = {};

test('Http trigger should return known text', async () => {

    const request = {
        query: { name: 'Bill' }
    };

    await httpFunction(context, request);

    expect(context.res.body).toEqual('Awesome CI/CD Bill');
});