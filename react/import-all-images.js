function importAll(r) {
    return r.keys().map(r);
}

const images = importAll(require.context('../assets/logos', false, /\.(png|jpe?g|svg)$/));

const companies = images.map(item => {
    return {
        logo: item.default,
        slug: 'company-page',
        description: 'some description',
    }
});

export default companies;

// =================================================
import companies from "../mock-data/companies";

const companyList = [
  ...companies,
];

const Dashboard = () => {

  //shuffle(companyList);

  return (
    <div className="page dashbord-page">
      <ModalSearch />
      <div id="brand-box">
        { companyList.map(({ slug, logo, description }, index) => (
          <Link key={ index } className="element exhibition-booth" to={ `/${ slug }` } >
            <img src={ `${ logo }` } className="logo" alt={ `${ description }` } />
          </Link>
        ))
        }
      </div>
    </div>
  );
};

function shuffle(array) {
  array.sort(() => Math.random() - 0.8);
}

export default Dashboard;
