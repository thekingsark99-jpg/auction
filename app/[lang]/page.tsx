import { getSettings } from '../../utils/api';

export default async function Page({ params }: { params: { lang: string } }) {
  const settings = await getSettings();
  return (
    <main>
      <h1>Language: {params.lang}</h1>
      <pre>{JSON.stringify(settings, null, 2)}</pre>
    </main>
  );
}
