import { getSettings } from '../../utils/api';

import { use } from "react";
    
export default function CategoryDetail({params}: {params: Promise<{ id: string }>}) {
const { id } = use(params);
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
