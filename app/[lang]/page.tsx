import { getSettings } from '../../utils/api';

type Props = {
  params: { lang: string }
};

export default async function Page({ params }: Props) {
  const settings = await getSettings();
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
