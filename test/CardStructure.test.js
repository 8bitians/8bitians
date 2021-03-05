const { accounts, contract } = require('@openzeppelin/test-environment');

const CardStructure = contract.fromArtifact('CardStructure');
let myContract;

describe('CardStructure', function () {
  const [ owner, user ] = accounts;

  beforeEach(async function () {
    myContract = await CardStructure.new({ from: owner });
  });

  it('deployer is owner', async function () {
    expect(await myContract.owner()).toEqual(owner);
  });

  it('create series and card type from owner', async function () {
    await myContract.createCardSeries('New Series', { from: owner });
    const newSeries = await myContract.retrieveSeries();
    expect(newSeries[0].name).toEqual('New Series');
    await myContract.createCardType('New Type', 0, 3, { from: owner });
    const newType = await myContract.retrieveTypes();
    expect(newType[0].name).toEqual('New Type');
  })

  it('change name of series and type from owner', async function () {
    await myContract.createCardSeries('New Series', { from: owner });
    await myContract.createCardType('New Type', 0, 3, { from: owner });
    await myContract.updateSeriesName(0, 'New New Series', { from: owner });
    const changedSeries = await myContract.retrieveSeries();
    expect(changedSeries[0].name).toEqual('New New Series');
    await myContract.updateTypeName(0, 'New New Type', { from: owner });
    const changedType = await myContract.retrieveTypes();
    expect(changedType[0].name).toEqual('New New Type');
  })
});