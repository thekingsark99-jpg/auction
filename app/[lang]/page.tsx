import type { Metadata } from "next"

// make this a promise
interface Props {
  params: Promise<{ slug?: string }>;
}

export async function generateMetadata({ params}: Props): Promise<Metadata> {
  const { slug } = await params; //await here

}
