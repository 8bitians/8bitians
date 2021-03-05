const { accounts, contract } = require('@openzeppelin/test-environment');
const { ether } = require('@openzeppelin/test-helpers');

const CardFactory = contract.fromArtifact('CardFactory');
let myContract;

describe('CardFactory', function () {
  const [ owner, user, sender ] = accounts;

  beforeEach(async function () {
    myContract = await CardFactory.new({ from: owner });
  });

  it('create initial card', async function () {
    await myContract.createCardSeries('New Series', { from: owner });
    await myContract.createCardType('Rarity 1', 0, 1, { from: owner });
    await myContract.createCardType('Rarity 2', 0, 2, { from: owner });
    await myContract.createCardType('Rarity 3', 0, 3, { from: owner });
    await myContract.createCardType('Rarity 4', 0, 4, { from: owner });
    await myContract.createCardType('Rarity 5', 0, 5, { from: owner });
    await myContract.createInitialCard({ from: user });
    const cards = await myContract.retrieveCards();
    expect(cards.length).toEqual(1);
  });

  it('buy a card pack', async function () {
    await myContract.createCardSeries('New Series', { from: owner });
    await myContract.createCardType('Rarity 1', 0, 1, { from: owner });
    await myContract.createCardType('Rarity 2', 0, 2, { from: owner });
    await myContract.createCardType('Rarity 3', 0, 3, { from: owner });
    await myContract.createCardType('Rarity 4', 0, 4, { from: owner });
    await myContract.createCardType('Rarity 5', 0, 5, { from: owner });
    await myContract.buyCardPack(5, { from: sender, value: ether('0.005') });
    const cards = await myContract.retrieveCards();
    expect(cards.length).toEqual(5);
  });
});