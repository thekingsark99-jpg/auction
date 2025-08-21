import { getSettings } from '../../utils/api';

import use from 'react' // import this line

type tParams = Promise<{ slug: string[] }>;

export default function Challenge({ params }: { params:  tParams }) {
  const { slug }: {slug: string[]} = use(params) ; // fix this line
  const productID = slug[1];
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
