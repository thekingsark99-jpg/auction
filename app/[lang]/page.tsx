import { getSettings } from '../../utils/api';

import use from 'react' // import this line

export default function Challenge({ params }: { params:  tParams }) {

  return (
    <main>
      <h1>Language: {params.lang}</h1>
      <pre>{JSON.stringify(settings, null, 2)}</pre>
    </main>
  );
}

export function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' }
  ];
}
