const { accounts, contract } = require('@openzeppelin/test-environment');
const [ owner ] = accounts;

const { expect } = require('chai');

const CardStructure = contract.fromArtifact('CardStructure');

describe('CardStructure', function () {

  beforeEach(async function () {
    this.contract = await CardStructure.new({ from: owner });
  });

  it('deployer is owner', async function () {
    expect(await this.contract.owner()).to.equal(owner);
  });

  it('create series and card type from owner', async function () {
    await this.contract.createCardSeries('New Series', { from: owner });
    const newSeries = await this.contract.retrieveSeries();
    expect((newSeries[0].name)).to.equal('New Series');
    await this.contract.createCardType('New Type', 0, 3, { from: owner });
    const newType = await this.contract.retrieveTypes();
    expect((newType[0].name)).to.equal('New Type');
  })

  it('change name of series and type from owner', async function () {
    await this.contract.createCardSeries('New Series', { from: owner });
    const newSeries = await this.contract.retrieveSeries();
    await this.contract.createCardType('New Type', 0, 3, { from: owner });
    const newType = await this.contract.retrieveTypes();
    await this.contract.updateSeriesName(0, 'New New Series', { from: owner });
    const changedSeries = await this.contract.retrieveSeries();
    expect((changedSeries[0].name)).to.equal('New New Series');
    await this.contract.updateTypeName(0, 'New New Type', { from: owner });
    const changedType = await this.contract.retrieveTypes();
    expect((changedType[0].name)).to.equal('New New Type');
  })
});